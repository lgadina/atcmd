unit uEts2SerialTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Spin, StdCtrls,
  ActnList, Buttons, ExtCtrls, scsData, scsATSerialThread;

type

  { TForm1 }

  TForm1 = class(TForm)
    actElectricEnable: TAction;
    actHighBeamLights: TAction;
    actEngineBracke: TAction;
    actAccumWarning: TAction;
    actEngineEnabled: TAction;
    actFuelWarning: TAction;
    actOilPressWarning: TAction;
    actWaterTemp: TAction;
    actParkingBracke: TAction;
    actLowBeamLights: TAction;
    actParkingLights: TAction;
    actRightBlinker: TAction;
    actLeftBlinker: TAction;
    ActionList1: TActionList;
    Button1: TButton;
    Button2: TButton;
    cbLeftBlinker: TCheckBox;
    cbRightBlinker: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    cbFuelWarning: TCheckBox;
    fesWheel: TFloatSpinEdit;
    fseFuelCapacity: TFloatSpinEdit;
    fseOilPressure: TFloatSpinEdit;
    fseOilTemp: TFloatSpinEdit;
    fseTransmission: TFloatSpinEdit;
    fseBrakeTemp: TFloatSpinEdit;
    fseWaterTemp: TFloatSpinEdit;
    fseAccumVoltage: TFloatSpinEdit;
    fseEngine: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    seSpeed: TSpinEdit;
    seRpm: TSpinEdit;
    seFuel: TSpinEdit;
    seAir: TSpinEdit;
    seGear: TSpinEdit;
    seCruiseSpeed: TSpinEdit;
    Timer1: TTimer;
    procedure actAccumWarningExecute(Sender: TObject);
    procedure actAccumWarningUpdate(Sender: TObject);
    procedure actElectricEnableExecute(Sender: TObject);
    procedure actElectricEnableUpdate(Sender: TObject);
    procedure actEngineBrackeExecute(Sender: TObject);
    procedure actEngineBrackeUpdate(Sender: TObject);
    procedure actEngineEnabledExecute(Sender: TObject);
    procedure actEngineEnabledUpdate(Sender: TObject);
    procedure actFuelWarningExecute(Sender: TObject);
    procedure actFuelWarningUpdate(Sender: TObject);
    procedure actHighBeamLightsExecute(Sender: TObject);
    procedure actHighBeamLightsUpdate(Sender: TObject);
    procedure actLeftBlinkerExecute(Sender: TObject);
    procedure actLeftBlinkerUpdate(Sender: TObject);
    procedure actLowBeamLightsExecute(Sender: TObject);
    procedure actLowBeamLightsUpdate(Sender: TObject);
    procedure actOilPressWarningExecute(Sender: TObject);
    procedure actOilPressWarningUpdate(Sender: TObject);
    procedure actParkingBrackeExecute(Sender: TObject);
    procedure actParkingBrackeUpdate(Sender: TObject);
    procedure actParkingLightsExecute(Sender: TObject);
    procedure actParkingLightsUpdate(Sender: TObject);
    procedure actRightBlinkerExecute(Sender: TObject);
    procedure actRightBlinkerUpdate(Sender: TObject);
    procedure actWaterTempExecute(Sender: TObject);
    procedure actWaterTempUpdate(Sender: TObject);
    procedure fesWheelChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure fseFuelCapacityChange(Sender: TObject);
    procedure fseOilPressureChange(Sender: TObject);
    procedure fseAccumVoltageChange(Sender: TObject);
    procedure fseBrakeTempChange(Sender: TObject);
    procedure fseEngineChange(Sender: TObject);
    procedure fseOilTempChange(Sender: TObject);
    procedure fseTransmissionChange(Sender: TObject);
    procedure fseWaterTempChange(Sender: TObject);
    procedure seAirChange(Sender: TObject);
    procedure seCruiseSpeedChange(Sender: TObject);
    procedure seGearChange(Sender: TObject);
    procedure seRpmChange(Sender: TObject);
    procedure seSpeedChange(Sender: TObject);
    procedure seFuelChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  protected
    FData: TEUT2Data;
    FTh: TscsATSerialThread;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.actElectricEnableExecute(Sender: TObject);
begin
  FData.electricEnabled := not FData.electricEnabled;
  if FData.electricEnabled then
   begin
     seSpeedChange(seSpeed);
     seRpmChange(seRpm);
     seAirChange(seAir);
     seFuelChange(seFuel);
   end else
    FData.engineEnabled:=False;
end;

procedure TForm1.actAccumWarningExecute(Sender: TObject);
begin
  FData.batteryVoltageWarning:= not FData.batteryVoltageWarning;
end;

procedure TForm1.actAccumWarningUpdate(Sender: TObject);
begin
  TAction(Sender).Checked:=FData.batteryVoltageWarning;
end;

procedure TForm1.actElectricEnableUpdate(Sender: TObject);
begin
  TAction(Sender).Checked:=FData.electricEnabled;
end;

procedure TForm1.actEngineBrackeExecute(Sender: TObject);
begin
 FData.motorBrake:= not FData.motorBrake;
end;

procedure TForm1.actEngineBrackeUpdate(Sender: TObject);
begin
  TAction(Sender).Checked:=FData.motorBrake;
end;

procedure TForm1.actEngineEnabledExecute(Sender: TObject);
begin
  if FData.electricEnabled then
   FData.engineEnabled:= true;
end;

procedure TForm1.actEngineEnabledUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:= FData.electricEnabled and not FData.engineEnabled;
end;

procedure TForm1.actFuelWarningExecute(Sender: TObject);
begin
  FData.fuelWarning:= not FData.fuelWarning;
end;

procedure TForm1.actFuelWarningUpdate(Sender: TObject);
begin
  TAction(Sender).Checked:= FData.fuelWarning;
end;

procedure TForm1.actHighBeamLightsExecute(Sender: TObject);
begin
  if FData.lightParking and FData.lightLowBeam then
   FData.lightHighBeam:= not FData.lightHighBeam;

end;

procedure TForm1.actHighBeamLightsUpdate(Sender: TObject);
begin
  if not FData.lightParking or not FData.lightLowBeam then
   FData.lightHighBeam := False;
   TAction(Sender).Checked:=FData.lightHighBeam;
end;

procedure TForm1.actLeftBlinkerExecute(Sender: TObject);
begin
  FData.leftBlinker:=not FData.leftBlinker;
  if not FData.leftBlinker then
   FData.leftBlinkerLight:=False;
end;

procedure TForm1.actLeftBlinkerUpdate(Sender: TObject);
begin
  TAction(Sender).Checked := Fdata.leftBlinker;
  TAction(Sender).Enabled := not FData.rightBlinker;
end;

procedure TForm1.actLowBeamLightsExecute(Sender: TObject);
begin
  if FData.lightParking then
    FData.lightLowBeam:= not FData.lightLowBeam;
  FData.lightHighBeam:= actHighBeamLights.Checked;
end;

procedure TForm1.actLowBeamLightsUpdate(Sender: TObject);
begin
  if not FData.lightParking then
   FData.lightLowBeam := False;
  TAction(Sender).Checked:= FData.lightLowBeam;
end;

procedure TForm1.actOilPressWarningExecute(Sender: TObject);
begin
  FData.oilPressureWarning:=not FData.oilPressureWarning;
end;

procedure TForm1.actOilPressWarningUpdate(Sender: TObject);
begin
  TAction(Sender).Checked:=FData.oilPressureWarning;
end;

procedure TForm1.actParkingBrackeExecute(Sender: TObject);
begin
  FData.parkingBrake:=not FData.parkingBrake;
end;

procedure TForm1.actParkingBrackeUpdate(Sender: TObject);
begin
  TAction(Sender).Checked:=FData.parkingBrake;
end;

procedure TForm1.actParkingLightsExecute(Sender: TObject);
begin
  FData.lightParking := not FData.lightParking;
  FData.lightLowBeam:= actLowBeamLights.Checked;
  FData.lightHighBeam:=actHighBeamLights.Checked;
end;

procedure TForm1.actParkingLightsUpdate(Sender: TObject);
begin
    TAction(Sender).Checked:= FData.lightParking;
end;

procedure TForm1.actRightBlinkerExecute(Sender: TObject);
begin
  FData.rightBlinker:= not FData.rightBlinker;
  if not (FData.rightBlinker) then
    FData.rightBlinkerLight:= false;
end;

procedure TForm1.actRightBlinkerUpdate(Sender: TObject);
begin
  TAction(Sender).Checked := Fdata.rightBlinker;
  TAction(Sender).Enabled := not FData.leftBlinker;
end;

procedure TForm1.actWaterTempExecute(Sender: TObject);
begin
  FData.waterTempWaring:= not FData.waterTempWaring;
end;

procedure TForm1.actWaterTempUpdate(Sender: TObject);
begin
  TAction(Sender).Checked:=FData.waterTempWaring;
end;

procedure TForm1.fesWheelChange(Sender: TObject);
begin
  FData.wearWheels:=fesWheel.Value;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FData.electricEnabled:=False;
  Sleep(1000);
end;

procedure TForm1.fseFuelCapacityChange(Sender: TObject);
begin
  FData.truckProperties.fuelCapacity:=fseFuelCapacity.Value;
end;

procedure TForm1.fseOilPressureChange(Sender: TObject);
begin
  FData.oilPressure:=fseOilPressure.Value;
end;

procedure TForm1.fseAccumVoltageChange(Sender: TObject);
begin
  FData.batteryVoltage:=fseAccumVoltage.Value;
end;

procedure TForm1.fseBrakeTempChange(Sender: TObject);
begin
  FData.brakeTemperature:= fseBrakeTemp.Value;
end;

procedure TForm1.fseEngineChange(Sender: TObject);
begin
  FData.wearEngine:= fseEngine.Value;
end;

procedure TForm1.fseOilTempChange(Sender: TObject);
begin
  Fdata.oilTemperature:= fseOilTemp.Value;
end;

procedure TForm1.fseTransmissionChange(Sender: TObject);
begin
  FData.wearTransmission:= fseTransmission.Value;
end;

procedure TForm1.fseWaterTempChange(Sender: TObject);
begin
  FData.waterTemperature:= fseWaterTemp.Value;
end;

procedure TForm1.seAirChange(Sender: TObject);
begin
  FData.breakAirPressure:=seAir.Value;
  FData.airPressureWarning:=FData.breakAirPressure < 60;
  FData.airPressureEmergency:=FData.breakAirPressure < 30;
end;

procedure TForm1.seCruiseSpeedChange(Sender: TObject);
begin
  FData.CruiseSpeed:= seCruiseSpeed.Value;
end;

procedure TForm1.seGearChange(Sender: TObject);
begin
  FData.gear:= seGear.Value;
end;

procedure TForm1.seRpmChange(Sender: TObject);
begin
  FData.rpm:= seRpm.Value;
end;

procedure TForm1.seSpeedChange(Sender: TObject);
begin
  FData.speed:=seSpeed.Value/10;
end;

procedure TForm1.seFuelChange(Sender: TObject);
begin
  FData.fuel:=seFuel.Value;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if cbRightBlinker.Checked then
  begin
    FData.rightBlinkerLight:= not FData.rightBlinkerLight;
  end;
  if cbLeftBlinker.Checked then
  begin
    FData.leftBlinkerLight:=not FData.leftBlinkerLight;
  end;
end;

constructor TForm1.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FData := TEUT2Data.create();
  FTh := TscsATSerialThread.Create(FData);
end;

destructor TForm1.Destroy;
begin
  FData.Free;
  FTh.Free;
  inherited Destroy;
end;

end.

