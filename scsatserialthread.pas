unit scsatserialthread;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  //Serial,
  synaser,
  scsData;

type

  { TscsATSerialThread }
  TOnETSCommandEvent = procedure(Sender: TObject; ACommand: String) of object;

  TscsATSerialThread = class(TThread)
  private
  type TscsSerialData = packed record
      case byte of
      0: (buffer: array [0..17] of byte);
      1: (data : bitpacked record
         spd: 0..$3FF;          //10
         cspd: 0..$3FF;         //10
         rpm: 0..$3FFF;         //14
         fuel: 0..$7FF;         //11
         air: 0..$FF;           //8
         wear: 0..$7F;          //7
         oilPressure: 0..$7F;   //7
         accumVoltage: 0..$1FF; // 9
         waterTemp: 0..$7FF;    // 11
         brakeTemp: 0..$FFF;    // 12
         Gear: 0..$1F;          //5
         Retarder: 0..$07;      //3
         leftBlinker, rightBlinker, leftBlinkerLight, rightBlinkerLight, lightParking,lightLowBeam,lightHighBeam,electricEnabled: boolean;
         parkingBracke, motorBrake, airPressureWarning, airPressureEmergency, fuelWarning, adblueWarning, oilPressureWarning, waterTempWaring: boolean;
         wheelWarning, engineEnabled, lightAuxFront, lightAuxRoof, lightBeacom, lightBrake, lightReverse, checkEngine: boolean;
         batteryVoltageWarning: boolean; // 1
         transmissionWarning: boolean;   // 1
         oilTemp: 0..$7FF;               // 11
      end;);
    end;
    (*  TscsSerialData = packed record
        case byte of
        0: (buffer: array [0..20] of byte);
        1: (
           spd: word;
           cspd: word;
           rpm: word;
           fuel: word;
           air:  byte;
           wear: byte;
           oilPressure: byte;
           GearRetarder: byte;
           flags1: bitpacked record
               leftBlinker, rightBlinker, leftBlinkerLight, rightBlinkerLight, lightParking,lightLowBeam,lightHighBeam,electricEnabled: boolean;
           end;
           flags2: bitpacked record
                 parkingBracke, motorBrake, airPressureWarning, airPressureEmergency, fuelWarning, adblueWarning, oilPressureWarning, waterTempWaring: boolean;
           end;
           flags3: bitpacked record
               wheelWarning, engineEnabled, lightAuxFront, lightAuxRoof, lightBeacom, lightBrake, lightReverse, checkEngine: boolean;
           end;
           accuVoltage: word;
           waterTemp: word;
           brakeTemp: word;
           );
      end;*)
    private
      FData: TEUT2Data;
      FCurrentCommand: String;
      FOnCommand: TOnETSCommandEvent;
      FSerialHandle: LongInt;
      FNewConnecting: Boolean;
      FComPort: TBlockSerial;
    protected
      procedure _open;
      procedure _close;
      function readData: String;
      function readDataOk: boolean;
      function readDataStr: String;
      function DataToStr: String;
      function SendData(AData: String): Integer;
      function SendAndWaitOk(AData: String): boolean;
      function SendAndReadData(AData: String): String;
      procedure Execute; override;
      procedure DoOnCommand(ACommand: String);
      procedure SendNotify;
    public
      constructor Create(AData: TEUT2Data);
      destructor Destroy; override;
      property OnCommand: TOnETSCommandEvent read FOnCommand write FOnCommand;
      class function map(val, in_min, in_max, out_min, out_max: integer): integer;
      class function setServoPulse(pulse: double): word;
      class function AngleToPulse(angle: Integer): word;
  end;

implementation

uses scssdk, windows;

{ TscsATSerialThread }

procedure TscsATSerialThread._open;
var S, EE: String;
begin
  if FComPort.Handle = INVALID_HANDLE_VALUE then
  begin
    FComPort.Connect('COM7');
    if FComPort.Handle <> INVALID_HANDLE_VALUE then
     begin
       FComPort.Config(115200, 8, 'N', 1, false, false);
       repeat
       until FComPort.Recvstring(5000) = 'DONE';
       FComPort.ATCommand('AT');
       if FComPort.ATResult then
         begin
           EE := SendAndReadData('AT+EE');
           if EE = '+EE:1'  then
              SendAndReadData('AT+EE=0');
           FNewConnecting := True;
         end;
     end;
  end;
  {if FSerialHandle = 0 then
   begin
     FSerialHandle:= SerOpen('COM6');
     if FSerialHandle <> 0 then
      begin
       SerSetParams(FserialHandle, 115200, 8, NoneParity, 1, []);
       SendData('AT');
       if not readDataOk then
         begin
            _close;
            exit;
         end;
       EE := SendAndReadData('AT+EE');

       if EE = '+EE:1' then
           SendAndWaitOk('AT+EE=0');
       FNewConnecting := True;
      end;
   end;}
end;

procedure TscsATSerialThread._close;
begin
  if FComPort.Handle <> INVALID_HANDLE_VALUE then
  begin
    FComPort.CloseSocket;
  end;
  {if FSerialHandle > 0 then
   begin
     SerSync(FserialHandle);
     SerFlushOutput(FserialHandle);
     SerClose(FserialHandle);
     FSerialHandle:=0;
     if FData.params.common.log <> nil then
       FData.params.common.log(SCS_LOG_TYPE_message, 'close port'); ;
   end;}
end;

function TscsATSerialThread.readData: String;
var InpBuf: String;
    Ch: char;
    status: ShortInt;
begin
  InpBuf:= '';
  status := 1;
  {while status > 0 do
   begin
     status := SerRead(FSerialHandle, Ch, 1);
     if ch=#13 then
      begin
       status := SerRead(FSerialHandle, Ch, 1);
       if ch=#10 then
         status := -1;
      end;
      if (Status > 0) then
        InpBuf:= InpBuf + Ch;
   end;}
  Result := InpBuf;
end;

function TscsATSerialThread.readDataOk: boolean;
var S: String;
    tm, tmval: QWord;
    timeOut: boolean;
begin
 S := '';
 tm:= GetTickCount64;
 repeat
   S := readData;
   tmval := GetTickCount64 - tm;;
   timeOut:= tmval > 2000;
   Sleep(1);
 until (S = 'OK') or (Terminated) or timeOut;
 if timeOut then
  begin
   if FData.params.common.log <> nil then
     FData.params.common.log(SCS_LOG_TYPE_error, scs_string_t('Timeout: '+tmval.ToString));
   _close;
   result := false;
  end else
   Result := S = 'OK';
end;

function TscsATSerialThread.readDataStr: String;
var Data: String;
begin
 Result := '';
 repeat
   Data := readData;
   Sleep(1);
 until Data <> '';
 if readDataOk then
  Result := Data;
end;

function TscsATSerialThread.DataToStr: String;
var S: TscsSerialData;
    k: byte;
begin
  Result := '';
  FillChar(S, sizeOf(S), 0);
  with s.data do
   begin
     spd:= Abs(Round(FData.speed*10));
     rpm:=Trunc(FData.rpm);
     cspd:=Round(FData.CruiseSpeed*10);
     electricEnabled:=FData.electricEnabled;
     leftBlinker:=FData.leftBlinker;
     rightBlinker:=FData.rightBlinker;
     leftBlinkerLight:=FData.leftBlinkerLight;
     rightBlinkerLight:=FData.rightBlinkerLight;
     lightParking:=FData.lightParking;
     lightLowBeam:=FData.lightLowBeam;
     lightHighBeam:=FData.lightHighBeam;
     fuel:=trunc(FData.fuel);
     adblueWarning:=FData.adblueWarning;
     airPressureEmergency:=FData.airPressureEmergency;
     airPressureWarning:=FData.airPressureWarning;
     fuelWarning:=FData.fuelWarning;
     motorBrake:=FData.motorBrake;
     parkingBracke:=FData.parkingBrake;
     oilPressureWarning:=FData.oilPressureWarning;
     waterTempWaring:=FData.waterTempWaring;
     wheelWarning := FData.wearWheels > 0;
     engineEnabled:=FData.engineEnabled;
     lightAuxFront:=FData.lightAuxFront;
     lightAuxRoof:=FData.lightAuxRoof;
     lightBeacom:=FData.lightBeacom;
     lightBrake:=FData.lightBrake;
     lightReverse:=FData.lightReverse;
     checkEngine:= FData.checkEngine;
     air:=trunc(FData.breakAirPressure);
     wear:=Round(FData.wearTruck*100);
     oilPressure:=round(FData.oilPressure);
     Gear:= (FData.gear);
     accumVoltage:= Trunc(FData.batteryVoltage*10);
     batteryVoltageWarning:= FData.batteryVoltageWarning;
     transmissionWarning:= FData.transmissionWarning;
     waterTemp:= trunc(FData.waterTemperature*10);
     brakeTemp:= trunc(FData.brakeTemperature*10);
     oilTemp:=Trunc(FData.oilTemperature * 10);
   end;
  for k in s.buffer do
    Result := Result + IntToHex(k, 2);
end;

function TscsATSerialThread.SendData(AData: String): Integer;
Var Buf: String;
    i: integer;
begin
{  Buf := AData+#13;
  Result := 0;
  if FData.params.common.log <> nil then
   FData.params.common.log(SCS_LOG_TYPE_message, scs_string_t(Buf));
  Result := 0;
  if FSerialHandle <> 0 then
   result := SerWrite(FSerialHandle, Buf[1], Length(Buf));}
end;

function TscsATSerialThread.SendAndWaitOk(AData: String): boolean;
Var Txt: String;
begin
  Txt := SendAndReadData(AData);
  Result := Txt = 'OK';
  {SendData(AData);
  Result := readDataOk;}
  if not Result then
   if FData.params.common.log <> nil then
    FData.params.common.log(SCS_LOG_TYPE_error, scs_string_t('Not ok answer for '+AData));
end;

function TscsATSerialThread.SendAndReadData(AData: String): String;
var Str: TStringList;
begin
  Result := '';
  Str := TStringList.Create;
  try
    FCurrentCommand := AData;
    Synchronize(@SendNotify);
    Str.Text := FComPort.ATCommand(AData);
    if Str.Text <> '' then
     Result := Str[0];
  finally
    Str.Free;
  end;
  {
  if SendData(AData) > 0 then
    Result := readDataStr
  else
    Result := '';
  }
end;

procedure TscsATSerialThread.Execute;
var Buf: String;
    OldBuf: String;
    cn: byte;
begin
  OldBuf:= '';
  repeat
    FNewConnecting:= False;
    if FComPort.Handle = INVALID_HANDLE_VALUE then
     _open;
    if  FComPort.Handle <> INVALID_HANDLE_VALUE then
     begin
       if FData.truckProperties.changed or FNewConnecting then
       begin
         Buf := 'AT+EFLC='+Trunc(FData.truckProperties.fuelCapacity).ToString;
         if not SendAndWaitOk(Buf) then
         begin
           _close;
           Continue;
         end;
         FData.truckProperties.clearChanged;
       end;
       Buf := DataToStr;
       if Buf <> OldBuf then
       begin
        OldBuf:=Buf;
        if not SendAndWaitOk('AT+ERAW='+Buf) then
        begin
          _close;
          OldBuf := '';
        end;
        cn := 0;
       end;
       cn := cn + 1;
       if cn >= 200 then
       begin
         OldBuf:= '';
         cn := 0;
       end;
     end;
    Sleep(10);
  until Terminated;
end;

procedure TscsATSerialThread.DoOnCommand(ACommand: String);
begin
  if Assigned(FOnCommand) then
   FOnCommand(Self, ACommand);
end;

procedure TscsATSerialThread.SendNotify;
begin
  DoOnCommand(FCurrentCommand);
end;

class function TscsATSerialThread.map(val, in_min, in_max, out_min, out_max: integer
  ): integer;
begin
  result := (val - in_min) * (out_max - out_min) div (in_max - in_min) + out_min;
end;

class function TscsATSerialThread.setServoPulse(pulse: double): word;
var pulseLen: double;
begin
 pulseLen:= 1000000/50/4096;
 pulse := (pulse * 1000) / pulseLen;
 result := trunc(pulse);
end;

class function TscsATSerialThread.AngleToPulse(angle: Integer): word;
begin
  Result := setServoPulse(angle/90+0.5);
  if (result > 102) and (result < 510) then
   Result := Trunc(Result * 0.915);
end;

constructor TscsATSerialThread.Create(AData: TEUT2Data);
begin
  FData := AData;
  FComPort := TBlockSerial.Create;
  FComPort.AtTimeout:= 5000;
  inherited Create(False);
end;

destructor TscsATSerialThread.Destroy;
begin
  FComPort.Free;
  inherited Destroy;
end;

end.

