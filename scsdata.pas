unit scsData;

{$mode Delphi}{$H+}

interface
uses scssdk, scssdk_telemetry, SysUtils, Generics.Collections;

type

  { TEUT2Data }

  { TEUT2Wheel }

  TEUT2Wheel = class
  private
    Fliftable: boolean;
    Fpowered: boolean;
    Fradius: scs_float_t;
    Fsimulated: boolean;
    Fsteerable: boolean;
    procedure Setliftable(AValue: boolean);
    procedure Setpowered(AValue: boolean);
    procedure Setradius(AValue: scs_float_t);
    procedure Setsimulated(AValue: boolean);
    procedure Setsteerable(AValue: boolean);
  public
    property steerable: boolean read Fsteerable write Setsteerable;
    property simulated: boolean read Fsimulated write Setsimulated;
    property radius: scs_float_t read Fradius write Setradius;
    property powered: boolean read Fpowered write Setpowered;
    property liftable: boolean read Fliftable write Setliftable;
  end;

  { TEUT2TruckProperties }

  TEUT2TruckProperties = class
  private
    FadBlueCapacity: scs_float_t;
    FadblueWarningFactor: scs_float_t;
    FairPressuerEmergency: scs_float_t;
    FairPresureWarning: scs_float_t;
    FbatteryVoltageWarning: scs_float_t;
    Fbrand: String;
    FbrandId: string;
    FfuelCapacity: scs_float_t;
    FfuelWarningFactor: scs_float_t;
    FfwdGearCount: scs_u32_t;
    Fid: String;
    Fname: String;
    FoilPresureWarning: scs_float_t;
    FrevGearCount: scs_u32_t;
    FrpmLimit: scs_float_t;
    FwaterTemperatureWarning: scs_float_t;
    Fwheels: TObjectList<TEUT2Wheel>;
    FwheelsCount: scs_u32_t;
    FChanged: boolean;
    function GetChanged: boolean;
    procedure SetadBlueCapacity(AValue: scs_float_t);
    procedure SetadblueWarningFactor(AValue: scs_float_t);
    procedure SetairPressuerEmergency(AValue: scs_float_t);
    procedure SetairPresureWarning(AValue: scs_float_t);
    procedure SetbatteryVoltageWarning(AValue: scs_float_t);
    procedure Setbrand(AValue: String);
    procedure SetbrandId(AValue: string);
    procedure SetfuelCapacity(AValue: scs_float_t);
    procedure SetfuelWarningFactor(AValue: scs_float_t);
    procedure SetfwdGearCount(AValue: scs_u32_t);
    procedure Setid(AValue: String);
    procedure Setname(AValue: String);
    procedure SetoilPresureWarning(AValue: scs_float_t);
    procedure SetrevGearCount(AValue: scs_u32_t);
    procedure SetrpmLimit(AValue: scs_float_t);
    procedure SetwaterTemperatureWarning(AValue: scs_float_t);
    procedure SetwheelsCount(AValue: scs_u32_t);
  protected
    procedure SetChanged;
  public
    constructor Create;
    destructor Destroy; override;
    property brandId: string read FbrandId write SetbrandId;
    property id: String read Fid write Setid;
    property name: String read Fname write Setname;
    property brand: String read Fbrand write Setbrand;
    property fuelCapacity: scs_float_t read FfuelCapacity write SetfuelCapacity;
    property fuelWarningFactor: scs_float_t read FfuelWarningFactor write SetfuelWarningFactor;
    property adBlueCapacity: scs_float_t read FadBlueCapacity write SetadBlueCapacity;
    property adblueWarningFactor: scs_float_t read FadblueWarningFactor write SetadblueWarningFactor;
    property airPresureWarning: scs_float_t read FairPresureWarning write SetairPresureWarning;
    property airPressuerEmergency: scs_float_t read FairPressuerEmergency write SetairPressuerEmergency;
    property oilPresureWarning: scs_float_t read FoilPresureWarning write SetoilPresureWarning;
    property waterTemperatureWarning: scs_float_t read FwaterTemperatureWarning write SetwaterTemperatureWarning;
    property batteryVoltageWarning: scs_float_t read FbatteryVoltageWarning write SetbatteryVoltageWarning;
    property rpmLimit: scs_float_t read FrpmLimit write SetrpmLimit;
    property fwdGearCount: scs_u32_t read FfwdGearCount write SetfwdGearCount;
    property revGearCount: scs_u32_t read FrevGearCount write SetrevGearCount;
    property wheelsCount: scs_u32_t read FwheelsCount write SetwheelsCount;
    property wheels: TObjectList<TEUT2Wheel> read Fwheels;
    property changed: boolean read GetChanged;
    procedure clearChanged;
  end;

  TEUT2Data = class
  private
    Fadblue: scs_float_t;
    FadblueAverage: scs_float_t;
    FadblueWarning: boolean;
    FairPressureEmergency: boolean;
    FairPressureWarning: boolean;
    FbatteryVoltage: scs_float_t;
    FbatteryVoltageWarning: boolean;
    FbrakeTemperature: scs_float_t;
    FbreakAirPressure: scs_float_t;
    FChanged: boolean;
    FCruiseSpeed: scs_float_t;
    FelectricEnabled: boolean;
    FengineEnabled: boolean;
    Ffuel: scs_float_t;
    FfuelAverage: scs_float_t;
    FfuelRange: scs_float_t;
    FfuelWarning: boolean;
    Fgear: scs_s32_t;
    FleftBlinker: boolean;
    FleftBlinkerLight: boolean;
    FlightAuxFront: boolean;
    FlightAuxRoof: boolean;
    FlightBeacom: boolean;
    FlightBrake: boolean;
    FlightHighBeam: boolean;
    FlightLowBeam: boolean;
    FlightParking: boolean;
    FlightReverse: boolean;
    FmotorBrake: Boolean;
    FnavDistance: scs_float_t;
    FnavSpeedLimit: scs_float_t;
    FnavTime: scs_float_t;
    Fodometer: scs_float_t;
    FoilPressure: scs_float_t;
    FoilPressureWarning: boolean;
    FoilTemperature: scs_float_t;
    FparkingBrake: boolean;
    fpscs_telemetry_init_params_t: scs_telemetry_init_params_t;
    FrightBlinker: boolean;
    FrightBlinkerLight: boolean;
    Frpm: scs_float_t;
    Fspeed: scs_float_t;
    FTruckProperties: TEUT2TruckProperties;
    FwaterTemperature: scs_float_t;
    FwaterTempWaring: boolean;
    FwearCabin: scs_float_t;
    FwearChassis: scs_float_t;
    FwearEngine: scs_float_t;
    FwearTransmission: scs_float_t;
    FwearWheels: scs_float_t;
    FwipersOn: scs_u8_t;
    function GetCheckEngine: boolean;
    function GetSpeedKmH: scs_float_t;
    function GetTransmissionWarning: boolean;
    function GetWearTruck: scs_float_t;
    procedure Setadblue(AValue: scs_float_t);
    procedure SetadblueAverage(AValue: scs_float_t);
    procedure SetadblueWarning(AValue: boolean);
    procedure SetairPressureEmergency(AValue: boolean);
    procedure SetairPressureWarning(AValue: boolean);
    procedure SetbatteryVoltage(AValue: scs_float_t);
    procedure SetbatteryVoltageWarning(AValue: boolean);
    procedure SetbrakeTemperature(AValue: scs_float_t);
    procedure SetbreakAirPressure(AValue: scs_float_t);
    procedure SetCruiseSpeed(AValue: scs_float_t);
    procedure SetelectricEnabled(AValue: boolean);
    procedure SetengineEnabled(AValue: boolean);
    procedure Setfuel(AValue: scs_float_t);
    procedure SetfuelAverage(AValue: scs_float_t);
    procedure SetfuelRange(AValue: scs_float_t);
    procedure SetfuelWarning(AValue: boolean);
    procedure Setgear(AValue: scs_s32_t);
    procedure SetleftBlinker(AValue: boolean);
    procedure SetleftBlinkerLight(AValue: boolean);
    procedure SetlightAuxFront(AValue: boolean);
    procedure SetlightAuxRoof(AValue: boolean);
    procedure SetlightBeacom(AValue: boolean);
    procedure SetlightBrake(AValue: boolean);
    procedure SetlightHighBeam(AValue: boolean);
    procedure SetlightLowBeam(AValue: boolean);
    procedure SetlightParking(AValue: boolean);
    procedure SetlightReverse(AValue: boolean);
    procedure SetmotorBrake(AValue: Boolean);
    procedure SetnavDistance(AValue: scs_float_t);
    procedure SetnavSpeedLimit(AValue: scs_float_t);
    procedure SetnavTime(AValue: scs_float_t);
    procedure Setodometer(AValue: scs_float_t);
    procedure SetoilPressure(AValue: scs_float_t);
    procedure SetoilPressureWarning(AValue: boolean);
    procedure SetoilTemperature(AValue: scs_float_t);
    procedure SetparkingBrake(AValue: boolean);
    procedure SetrightBlinker(AValue: boolean);
    procedure SetrightBlinkerLight(AValue: boolean);
    procedure Setrpm(AValue: scs_float_t);
    procedure Setspeed(AValue: scs_float_t);
    procedure SetwaterTemperature(AValue: scs_float_t);
    procedure SetwaterTempWaring(AValue: boolean);
    procedure SetwearCabin(AValue: scs_float_t);
    procedure SetwearChassis(AValue: scs_float_t);
    procedure SetwearEngine(AValue: scs_float_t);
    procedure SetwearTransmission(AValue: scs_float_t);
    procedure SetwearWheels(AValue: scs_float_t);
    procedure SetwipersOn(AValue: scs_u8_t);
  protected
    procedure setChanged;
    procedure clearChanged;
  public
    constructor create(AParams: scs_telemetry_init_params_t); overload;
    constructor create; overload;
    destructor Destroy; override;
    property speed: scs_float_t read Fspeed write Setspeed;
    property speedKmH: scs_float_t read GetSpeedKmH;
    property rpm:   scs_float_t read Frpm write Setrpm;
    property gear:  scs_s32_t read Fgear write Setgear;
    property breakAirPressure: scs_float_t read FbreakAirPressure write SetbreakAirPressure;
    property params: scs_telemetry_init_params_t read fpscs_telemetry_init_params_t;
    property Changed: boolean read FChanged;
    property CruiseSpeed: scs_float_t read FCruiseSpeed write SetCruiseSpeed;
    property brakeTemperature: scs_float_t read FbrakeTemperature write SetbrakeTemperature;
    property fuel: scs_float_t read Ffuel write Setfuel;
    property fuelAverage: scs_float_t read FfuelAverage write SetfuelAverage;
    property fuelRange: scs_float_t read FfuelRange write SetfuelRange;
    property adblue: scs_float_t read Fadblue write Setadblue;
    property adblueAverage: scs_float_t read FadblueAverage write SetadblueAverage;
    property oilPressure: scs_float_t read FoilPressure write SetoilPressure;
    property oilTemperature: scs_float_t read FoilTemperature write SetoilTemperature;
    property waterTemperature: scs_float_t read FwaterTemperature write SetwaterTemperature;
    property batteryVoltage: scs_float_t read FbatteryVoltage write SetbatteryVoltage;

    property parkingBrake: boolean read FparkingBrake write SetparkingBrake;
    property motorBrake: Boolean read FmotorBrake write SetmotorBrake;
    property airPressureWarning: boolean read FairPressureWarning write SetairPressureWarning;
    property airPressureEmergency: boolean read FairPressureEmergency write SetairPressureEmergency;
    property fuelWarning: boolean read FfuelWarning write SetfuelWarning;
    property adblueWarning: boolean read FadblueWarning write SetadblueWarning;
    property oilPressureWarning: boolean read FoilPressureWarning write SetoilPressureWarning;
    property waterTempWaring: boolean read FwaterTempWaring write SetwaterTempWaring;
    property batteryVoltageWarning: boolean read FbatteryVoltageWarning write SetbatteryVoltageWarning;
    property electricEnabled: boolean read FelectricEnabled write SetelectricEnabled;
    property engineEnabled: boolean read FengineEnabled write SetengineEnabled;
    property leftBlinker: boolean read FleftBlinker write SetleftBlinker;
    property rightBlinker: boolean read FrightBlinker write SetrightBlinker;
    property leftBlinkerLight: boolean read FleftBlinkerLight write SetleftBlinkerLight;
    property rightBlinkerLight: boolean read FrightBlinkerLight write SetrightBlinkerLight;
    property lightParking: boolean read FlightParking write SetlightParking;
    property lightLowBeam: boolean read FlightLowBeam write SetlightLowBeam;
    property lightHighBeam: boolean read FlightHighBeam write SetlightHighBeam;
    property lightAuxFront: boolean read FlightAuxFront write SetlightAuxFront;
    property lightAuxRoof: boolean read FlightAuxRoof write SetlightAuxRoof;
    property lightBeacom: boolean read FlightBeacom write SetlightBeacom;
    property lightBrake: boolean read FlightBrake write SetlightBrake;
    property lightReverse: boolean read FlightReverse write SetlightReverse;
    property wipersOn: scs_u8_t read FwipersOn write SetwipersOn;

    property wearEngine: scs_float_t read FwearEngine write SetwearEngine;
    property wearTransmission: scs_float_t read FwearTransmission write SetwearTransmission;
    property wearCabin: scs_float_t read FwearCabin write SetwearCabin;
    property wearChassis: scs_float_t read FwearChassis write SetwearChassis;
    property wearWheels: scs_float_t read FwearWheels write SetwearWheels;
    property wearTruck: scs_float_t read GetWearTruck;
    property odometer: scs_float_t read Fodometer write Setodometer;
    property navDistance: scs_float_t read FnavDistance write SetnavDistance;
    property navTime: scs_float_t read FnavTime write SetnavTime;
    property navSpeedLimit: scs_float_t read FnavSpeedLimit write SetnavSpeedLimit;
    property checkEngine: boolean read GetCheckEngine;
    property transmissionWarning: boolean read GetTransmissionWarning;

    property truckProperties: TEUT2TruckProperties read FTruckProperties;

    function AsString: String;
  end;

implementation

uses Math;

{ TEUT2Wheel }

procedure TEUT2Wheel.Setliftable(AValue: boolean);
begin
  if Fliftable=AValue then Exit;
  Fliftable:=AValue;
end;

procedure TEUT2Wheel.Setpowered(AValue: boolean);
begin
  if Fpowered=AValue then Exit;
  Fpowered:=AValue;
end;

procedure TEUT2Wheel.Setradius(AValue: scs_float_t);
begin
  if Fradius=AValue then Exit;
  Fradius:=AValue;
end;

procedure TEUT2Wheel.Setsimulated(AValue: boolean);
begin
  if Fsimulated=AValue then Exit;
  Fsimulated:=AValue;
end;

procedure TEUT2Wheel.Setsteerable(AValue: boolean);
begin
  if Fsteerable=AValue then Exit;
  Fsteerable:=AValue;
end;

{ TEUT2TruckProperties }

procedure TEUT2TruckProperties.SetadBlueCapacity(AValue: scs_float_t);
begin
  if FadBlueCapacity=AValue then Exit;
  FadBlueCapacity:=AValue;
  SetChanged;
end;

function TEUT2TruckProperties.GetChanged: boolean;
begin
  Result := FChanged;
end;

procedure TEUT2TruckProperties.SetadblueWarningFactor(AValue: scs_float_t);
begin
  if FadblueWarningFactor=AValue then Exit;
  FadblueWarningFactor:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetairPressuerEmergency(AValue: scs_float_t);
begin
  if FairPressuerEmergency=AValue then Exit;
  FairPressuerEmergency:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetairPresureWarning(AValue: scs_float_t);
begin
  if FairPresureWarning=AValue then Exit;
  FairPresureWarning:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetbatteryVoltageWarning(AValue: scs_float_t);
begin
  if FbatteryVoltageWarning=AValue then Exit;
  FbatteryVoltageWarning:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.Setbrand(AValue: String);
begin
  if Fbrand=AValue then Exit;
  Fbrand:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetbrandId(AValue: string);
begin
  if FbrandId=AValue then Exit;
  FbrandId:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetfuelCapacity(AValue: scs_float_t);
begin
  if FfuelCapacity=AValue then Exit;
  FfuelCapacity:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetfuelWarningFactor(AValue: scs_float_t);
begin
  if FfuelWarningFactor=AValue then Exit;
  FfuelWarningFactor:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetfwdGearCount(AValue: scs_u32_t);
begin
  if FfwdGearCount=AValue then Exit;
  FfwdGearCount:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.Setid(AValue: String);
begin
  if Fid=AValue then Exit;
  Fid:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.Setname(AValue: String);
begin
  if Fname=AValue then Exit;
  Fname:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetoilPresureWarning(AValue: scs_float_t);
begin
  if FoilPresureWarning=AValue then Exit;
  FoilPresureWarning:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetrevGearCount(AValue: scs_u32_t);
begin
  if FrevGearCount=AValue then Exit;
  FrevGearCount:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetrpmLimit(AValue: scs_float_t);
begin
  if FrpmLimit=AValue then Exit;
  FrpmLimit:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetwaterTemperatureWarning(AValue: scs_float_t);
begin
  if FwaterTemperatureWarning=AValue then Exit;
  FwaterTemperatureWarning:=AValue;
  SetChanged;
end;

procedure TEUT2TruckProperties.SetwheelsCount(AValue: scs_u32_t);
var b: scs_u32_t;
begin
  if FwheelsCount=AValue then Exit;
  Fwheels.Clear;
  FwheelsCount:=AValue;
  for b := 0 to AValue - 1 do
   Fwheels.Add(TEUT2Wheel.Create);
  SetChanged;
end;

procedure TEUT2TruckProperties.SetChanged;
begin
  FChanged := True;
end;

constructor TEUT2TruckProperties.Create;
begin
  Fwheels := TObjectList<TEUT2Wheel>.Create;
  FChanged:= False;
end;

destructor TEUT2TruckProperties.Destroy;
begin
  Fwheels.Free;
  inherited Destroy;
end;

procedure TEUT2TruckProperties.clearChanged;
begin
  FChanged:= False;
end;

{ TEUT2Data }

procedure TEUT2Data.Setgear(AValue: scs_s32_t);
begin
  if Fgear=AValue then Exit;
  Fgear:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetleftBlinker(AValue: boolean);
begin
  if FleftBlinker=AValue then Exit;
  FleftBlinker:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetleftBlinkerLight(AValue: boolean);
begin
  if FleftBlinkerLight=AValue then Exit;
  FleftBlinkerLight:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightAuxFront(AValue: boolean);
begin
  if FlightAuxFront=AValue then Exit;
  FlightAuxFront:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightAuxRoof(AValue: boolean);
begin
  if FlightAuxRoof=AValue then Exit;
  FlightAuxRoof:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightBeacom(AValue: boolean);
begin
  if FlightBeacom=AValue then Exit;
  FlightBeacom:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightBrake(AValue: boolean);
begin
  if FlightBrake=AValue then Exit;
  FlightBrake:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightHighBeam(AValue: boolean);
begin
  if FlightHighBeam=AValue then Exit;
  FlightHighBeam:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightLowBeam(AValue: boolean);
begin
  if FlightLowBeam=AValue then Exit;
  FlightLowBeam:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightParking(AValue: boolean);
begin
  if FlightParking=AValue then Exit;
  FlightParking:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetlightReverse(AValue: boolean);
begin
  if FlightReverse=AValue then Exit;
  FlightReverse:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetmotorBrake(AValue: Boolean);
begin
  if FmotorBrake=AValue then Exit;
  FmotorBrake:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetnavDistance(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FnavDistance=AValue then Exit;
  FnavDistance:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetnavSpeedLimit(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, 0);
  if FnavSpeedLimit=AValue then Exit;
  FnavSpeedLimit:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetnavTime(AValue: scs_float_t);
begin
  if FnavTime=AValue then Exit;
  FnavTime:=AValue;
  setChanged;
end;

procedure TEUT2Data.Setodometer(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if Fodometer=AValue then Exit;
  Fodometer:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetoilPressure(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -1);
  if FoilPressure=AValue then Exit;
  FoilPressure:=AValue;
end;

procedure TEUT2Data.SetoilPressureWarning(AValue: boolean);
begin
  if FoilPressureWarning=AValue then Exit;
  FoilPressureWarning:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetoilTemperature(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, 0);
  if FoilTemperature=AValue then Exit;
  FoilTemperature:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetparkingBrake(AValue: boolean);
begin
  if FparkingBrake=AValue then Exit;
  FparkingBrake:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetrightBlinker(AValue: boolean);
begin
  if FrightBlinker=AValue then Exit;
  FrightBlinker:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetrightBlinkerLight(AValue: boolean);
begin
  if FrightBlinkerLight=AValue then Exit;
  FrightBlinkerLight:=AValue;
  setChanged;
end;

function TEUT2Data.GetSpeedKmH: scs_float_t;
begin
  Result := RoundTo(Fspeed*3.6, 0);
end;

function TEUT2Data.GetTransmissionWarning: boolean;
begin
  result := FwearTransmission > 0;
end;

function TEUT2Data.GetCheckEngine: boolean;
begin
  Result := FelectricEnabled and ((FwearEngine > 0)
      or not FengineEnabled or FbatteryVoltageWarning or FwaterTempWaring or FoilPressureWarning);
end;

function TEUT2Data.GetWearTruck: scs_float_t;
begin
  Result := (FwearCabin+FwearChassis+FwearEngine+FwearTransmission+FwearWheels);
end;

procedure TEUT2Data.Setadblue(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, 0);
  if Fadblue=AValue then Exit;
  Fadblue:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetadblueAverage(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FadblueAverage=AValue then Exit;
  FadblueAverage:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetadblueWarning(AValue: boolean);
begin
  if FadblueWarning=AValue then Exit;
  FadblueWarning:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetairPressureEmergency(AValue: boolean);
begin
  if FairPressureEmergency=AValue then Exit;
  FairPressureEmergency:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetairPressureWarning(AValue: boolean);
begin
  if FairPressureWarning=AValue then Exit;
  FairPressureWarning:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetbatteryVoltage(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FbatteryVoltage=AValue then Exit;
  FbatteryVoltage:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetbatteryVoltageWarning(AValue: boolean);
begin
  if FbatteryVoltageWarning=AValue then Exit;
  FbatteryVoltageWarning:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetbrakeTemperature(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FbrakeTemperature=AValue then Exit;
  FbrakeTemperature:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetbreakAirPressure(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, 0);
  if FbreakAirPressure=AValue then Exit;
  FbreakAirPressure:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetCruiseSpeed(AValue: scs_float_t);
begin
  AValue:= RoundTo(AValue, 0);
  if FCruiseSpeed=AValue then Exit;
  FCruiseSpeed:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetelectricEnabled(AValue: boolean);
begin
  if FelectricEnabled=AValue then Exit;
  FelectricEnabled:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetengineEnabled(AValue: boolean);
begin
  if FengineEnabled=AValue then Exit;
  FengineEnabled:=AValue;
  setChanged;
end;

procedure TEUT2Data.Setfuel(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if Ffuel=AValue then Exit;
  Ffuel:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetfuelAverage(AValue: scs_float_t);
begin
  AValue:= RoundTo(AValue, -4);
  if FfuelAverage=AValue then Exit;
  FfuelAverage:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetfuelRange(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, 0);
  if FfuelRange=AValue then Exit;
  FfuelRange:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetfuelWarning(AValue: boolean);
begin
  if FfuelWarning=AValue then Exit;
  FfuelWarning:=AValue;
  setChanged;
end;

procedure TEUT2Data.Setrpm(AValue: scs_float_t);
begin
  AValue := RoundTo(AValue, -1);
  if Frpm=AValue then Exit;
  Frpm:=AValue;
  setChanged;
end;

procedure TEUT2Data.Setspeed(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if Fspeed=AValue then Exit;
  Fspeed:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwaterTemperature(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, 0);
  if FwaterTemperature=AValue then Exit;
  FwaterTemperature:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwaterTempWaring(AValue: boolean);
begin
  if FwaterTempWaring=AValue then Exit;
  FwaterTempWaring:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwearCabin(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FwearCabin=AValue then Exit;
  FwearCabin:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwearChassis(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FwearChassis=AValue then Exit;
  FwearChassis:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwearEngine(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FwearEngine=AValue then Exit;
  FwearEngine:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwearTransmission(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FwearTransmission=AValue then Exit;
  FwearTransmission:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwearWheels(AValue: scs_float_t);
begin
  AValue:=RoundTo(AValue, -2);
  if FwearWheels=AValue then Exit;
  FwearWheels:=AValue;
  setChanged;
end;

procedure TEUT2Data.SetwipersOn(AValue: scs_u8_t);
begin
  if FwipersOn=AValue then Exit;
  FwipersOn:=AValue;
  setChanged;
end;

procedure TEUT2Data.setChanged;
begin
  FChanged := true;
end;

procedure TEUT2Data.clearChanged;
begin
  FChanged:=False;
end;

constructor TEUT2Data.create(AParams: scs_telemetry_init_params_t);
begin
  create;
  fpscs_telemetry_init_params_t:= AParams;
end;

constructor TEUT2Data.create;
begin
  FTruckProperties := TEUT2TruckProperties.Create;
  clearChanged;
end;

destructor TEUT2Data.Destroy;
begin
  FTruckProperties.Free;
  inherited Destroy;
end;

function TEUT2Data.AsString: String;
begin
 result := Format('spd=%.0f;cspd=%.0f;rpm=%.0f;gr=%d;air=%f;bt=%f;fl=%f;flv=%f;flr=%f;ad=%f;adv=%f;op=%f;ot=%f;wt=%f;bv=%f'#13#10+
                  'pb=%d;mb=%d;apw=%d;ape=%d;fw=%d,aw=%d;opw=%d;wtw=%d;bvw=%d;ee=%d;ege=%d'#13#10+
                  'lb=%d%d;rb=%d%d;lg=%d%d%d%d%d%d;aux=%d%d;wp=%d'#13#10+
                  'odo=%f;dst=%f;slim=%f;ntm=%f;we=%f;wt=%f;wc=%f;wh=%f;ww=%f',
    [Fspeed, FCruiseSpeed, Frpm, Fgear, FbreakAirPressure, brakeTemperature, Ffuel, FfuelAverage, FfuelRange,
     Fadblue, FadblueAverage, FoilPressure, FoilTemperature, FwaterTemperature, FbatteryVoltage,
     ord(FparkingBrake), ord(FmotorBrake), ord(FairPressureWarning), ord(FairPressureEmergency),
     ord(FfuelWarning), ord(FadblueWarning), Ord(FoilPressureWarning), ord(FwaterTempWaring),
     ord(FbatteryVoltageWarning), ord(FelectricEnabled), ord(FengineEnabled),
     ord(FleftBlinker), ord(leftBlinkerLight), ord(FrightBlinker), ord(rightBlinkerLight),
     ord(FlightParking), ord(FlightLowBeam), ord(FlightHighBeam), ord(FlightBeacom), ord(FlightBrake), ord(FlightReverse),
     ord(FlightAuxFront), ord(FlightAuxRoof), FwipersOn,
     Fodometer, FnavDistance, FnavSpeedLimit, FnavTime,
     wearEngine, wearTransmission, wearCabin, wearChassis, wearWheels]);
 clearChanged;
end;

end.

