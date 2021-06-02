unit scsSerialThread;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Serial, scsData;
type

  { TscsSerialThread }

  TscsSerialThread = class(TThread)
  private
   type
    TscsSerialData = record
      case byte of
      0: (buffer: array [0..9] of byte);
      1: (
         spd: byte;
         cspd: byte;
         rpm: word;
         fuel: word;
         air:  byte;
         wear: byte;
         flags1: bitpacked record
             leftBlinker, rightBlinker, leftBlinkerLight, rightBlinkerLight, lightParking,lightLowBeam,lightHighBeam,electricEnabled: boolean;
         end;
         flags2: bitpacked record
             parkingBracke, motorBrake, airPressureWarning, airPressureEmergency, fuelWarning, adblueWarning, oilPressureWarning, waterTempWaring: boolean;
         end;

         );
    end;
  private
    FData: TEUT2Data;
    FSerialHandle: LongInt;
  protected
    procedure _open;
    procedure _close;
    procedure Execute; override;
  public
    constructor Create(AData: TEUT2Data);
  end;

implementation

{ TscsSerialThread }

procedure TscsSerialThread._open;
begin
  if FSerialHandle = 0 then
   begin
     FSerialHandle:= SerOpen('COM7');
     if FSerialHandle <> 0 then
       SerSetParams(FserialHandle, 115200, 8, NoneParity, 1, []);
   end;
end;

procedure TscsSerialThread._close;
begin
  if FSerialHandle > 0 then
   begin
     SerSync(FserialHandle);
     SerFlushOutput(FserialHandle);
     SerClose(FserialHandle);
     FSerialHandle:=0;
   end;
end;

procedure TscsSerialThread.Execute;
var S: TscsSerialData;
begin
 repeat
   _open;
   if FSerialHandle > 0 then
    begin
     FillChar(S, sizeOf(S), 0);
     s.spd:= Abs(Round(FData.speedKmH));
     s.rpm:=Trunc(FData.rpm);
     s.cspd:=Trunc(FData.CruiseSpeed*3.6);
     s.flags1.electricEnabled:=FData.electricEnabled;
     s.flags1.leftBlinker:=FData.leftBlinker;
     s.flags1.rightBlinker:=FData.rightBlinker;
     s.flags1.leftBlinkerLight:=FData.leftBlinkerLight;
     s.flags1.rightBlinkerLight:=FData.rightBlinkerLight;
     s.flags1.lightParking:=FData.lightParking;
     s.flags1.lightLowBeam:=FData.lightLowBeam;
     s.flags1.lightHighBeam:=FData.lightHighBeam;
     s.fuel:=trunc(FData.fuel);
     s.flags2.adblueWarning:=FData.adblueWarning;
     s.flags2.airPressureEmergency:=FData.airPressureEmergency;
     s.flags2.airPressureWarning:=FData.airPressureWarning;
     s.flags2.fuelWarning:=FData.fuelWarning;
     s.flags2.motorBrake:=FData.motorBrake;
     s.flags2.parkingBracke:=FData.parkingBrake;
     s.flags2.oilPressureWarning:=FData.oilPressureWarning;
     s.flags2.waterTempWaring:=FData.waterTempWaring;
     s.air:=trunc(FData.breakAirPressure);
     s.wear:=Round(FData.wearTruck*100);
     SerWrite(FserialHandle, s.buffer[0], Length(s.buffer));
     SerDrain(FSerialHandle);
    end;
   sleep(75);
 until Terminated;
 _close;
end;

constructor TscsSerialThread.Create(AData: TEUT2Data);
begin
  _open;
  FData := AData;
  inherited Create(False)
end;

end.

