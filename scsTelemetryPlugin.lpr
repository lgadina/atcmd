library scsTelemetryPlugin;

{$mode objfpc}{$H+}
{$i scssdk.inc}
{$i eut2/scssdk_telemetry_eut2.inc}
{$i common/scssdk_telemetry_common_channels.inc}
{$i common/scssdk_telemetry_truck_common_channels.inc}
{$i common/scssdk_telemetry_common_configs.inc}
{$i common/scssdk_telemetry_common_gameplay_events.inc}
{$i common/scssdk_telemetry_job_common_channels.inc}
{$i common/scssdk_telemetry_trailer_common_channels.inc}


uses
  Classes, SysUtils, scssdk, scssdk_value, scssdk_telemetry_event,
  scssdk_telemetry_channel, scssdk_telemetry, scsData, lnetbase, scsThread,
  scsatserialthread;

var
  eut2Data: TEUT2Data = nil;
  eut2Thread: TscsDataThread = nil;
  ser2Thread: TscsATSerialThread = nil;

procedure telemetry_store_float(const name: scs_string_t; const index: scs_u32_t; const value: pscs_value_t; const context: scs_context_t); cdecl;
begin
   case string(name) of
     SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure:  eut2Data.breakAirPressure := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_speed: eut2Data.speed:= value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_engine_rpm: eut2Data.rpm:= value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_cruise_control: eut2Data.CruiseSpeed:= value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_brake_temperature: eut2Data.brakeTemperature:= value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_fuel: eut2Data.fuel:= value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_fuel_average_consumption: eut2Data.fuelAverage := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_fuel_range: eut2Data.fuelRange := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_adblue: eut2Data.adblue := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_adblue_average_consumption: eut2Data.adblueAverage := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_oil_pressure: eut2Data.oilPressure := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_oil_temperature: eut2Data.oilTemperature := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_water_temperature: eut2Data.waterTemperature := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_battery_voltage: eut2Data.batteryVoltage := value^.value_float.value;

     SCS_TELEMETRY_TRUCK_CHANNEL_wear_engine: eut2Data.wearEngine := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_wear_transmission: eut2Data.wearTransmission := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_wear_cabin: eut2Data.wearCabin := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_wear_chassis: eut2Data.wearChassis := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_wear_wheels: eut2Data.wearWheels := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_odometer: eut2Data.odometer := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_navigation_distance: eut2Data.navDistance := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_navigation_time: eut2Data.navTime := value^.value_float.value;
     SCS_TELEMETRY_TRUCK_CHANNEL_navigation_speed_limit: eut2Data.navSpeedLimit := value^.value_float.value;

   end;
end;

procedure telemetry_store_s32(const name: scs_string_t; const index: scs_u32_t; const value: pscs_value_t; const context: scs_context_t); cdecl;
begin
   if name = SCS_TELEMETRY_TRUCK_CHANNEL_engine_gear then
     eut2Data.gear:= value^.value_s32.value;
end;

procedure telemetry_store_bool(const name: scs_string_t; const index: scs_u32_t; const value: pscs_value_t; const context: scs_context_t); cdecl;
begin
  case string(name) of
    SCS_TELEMETRY_TRUCK_CHANNEL_parking_brake: eut2Data.parkingBrake := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_motor_brake: eut2Data.motorBrake := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure_warning: eut2Data.airPressureWarning := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure_emergency: eut2Data.airPressureEmergency := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_fuel_warning: eut2Data.fuelWarning := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_adblue_warning: eut2Data.adblueWarning := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_oil_pressure_warning: eut2Data.oilPressureWarning := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_water_temperature_warning: eut2Data.waterTempWaring := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_battery_voltage_warning: eut2Data.batteryVoltageWarning := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_electric_enabled: eut2Data.electricEnabled := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_engine_enabled: eut2Data.engineEnabled := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_lblinker: eut2Data.leftBlinker := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_rblinker: eut2Data.rightBlinker := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_lblinker: eut2Data.leftBlinkerLight := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_rblinker: eut2Data.rightBlinkerLight := boolean(value^.value_bool.value);

    SCS_TELEMETRY_TRUCK_CHANNEL_light_parking: eut2Data.lightParking := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_low_beam: eut2Data.lightLowBeam := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_high_beam: eut2Data.lightHighBeam := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_aux_front: eut2Data.lightAuxFront := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_aux_roof: eut2Data.lightAuxRoof := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_beacon: eut2Data.lightBeacom := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_brake: eut2Data.lightBrake := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_light_reverse: eut2Data.lightReverse := boolean(value^.value_bool.value);
    SCS_TELEMETRY_TRUCK_CHANNEL_wipers: eut2Data.wipersOn := value^.value_bool.value;

  end;
end;

procedure telemetry_store_u32(const name: scs_string_t; const index: scs_u32_t; const value: pscs_value_t; const context: scs_context_t); cdecl;

begin

end;

procedure print_attributes(const attrs: pscs_named_value_t);
var buf: pscs_named_value_t;
    S: String;
begin
  buf := attrs;
  while buf^.name <> '' do
   begin
     if buf^.index <> SCS_U32_NIL then
       s := buf^.name+'['+buf^.index.ToString+']='
     else
       s := buf^.name + '=';

     case buf^.value.&type of
       1: s := s+buf^.value.value_bool.value.ToString;
       2: s := s+buf^.value.value_s32.value.ToString;
       3: s := s+buf^.value.value_u32.value.ToString;
       13: s := s+buf^.value.value_s64.value.ToString;
       4: s := s+buf^.value.value_u64.value.ToString;
       5: s := s+buf^.value.value_float.value.ToString;
       6: s := s+buf^.value.value_double.value.ToString;
       7: s := s + '{x='+buf^.value.value_fvector.x.ToString+',y='+buf^.value.value_fvector.y.ToString+',z='+buf^.value.value_fvector.y.ToString+'}';
       12: s := s+buf^.value.value_string.value;
     else
       s := '';
     end;
     if s <> '' then
      eut2Data.params.common.log(SCS_LOG_TYPE_message, scs_string_t(S));
     inc(buf);
   end;
end;

procedure fillTruckProperties(const attrs: pscs_named_value_t; const data: scs_context_t);
var _data: TEUT2Data;
    buf: pscs_named_value_t;
begin
  _data := TEUT2Data(data);
  buf := attrs;
  while buf^.name <> '' do
   begin
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_brand_id then
      _data.truckProperties.brandId:=buf^.value.value_string.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_brand then
      _data.truckProperties.brand:=buf^.value.value_string.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_id then
      _data.truckProperties.id:=buf^.value.value_string.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_fuel_capacity then
       _data.truckProperties.fuelCapacity:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_fuel_warning_factor then
        _data.truckProperties.fuelWarningFactor:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_adblue_capacity then
        _data.truckProperties.adBlueCapacity:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_adblue_warning_factor then
        _data.truckProperties.adblueWarningFactor:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_air_pressure_warning then
        _data.truckProperties.airPresureWarning:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_air_pressure_emergency then
        _data.truckProperties.airPressuerEmergency:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_oil_pressure_warning then
        _data.truckProperties.oilPresureWarning:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_water_temperature_warning then
        _data.truckProperties.waterTemperatureWarning:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_battery_voltage_warning then
        _data.truckProperties.batteryVoltageWarning:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_rpm_limit then
        _data.truckProperties.rpmLimit:=buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_forward_gear_count then
        _data.truckProperties.fwdGearCount:=buf^.value.value_s32.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_reverse_gear_count then
        _data.truckProperties.revGearCount:=buf^.value.value_s32.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_count then
       _data.truckProperties.wheelsCount:=buf^.value.value_s32.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_steerable then
       _data.truckProperties.wheels[buf^.index].steerable := buf^.value.value_bool.value = 1
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_simulated then
       _data.truckProperties.wheels[buf^.index].simulated := buf^.value.value_bool.value = 1
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_radius then
       _data.truckProperties.wheels[buf^.index].radius := buf^.value.value_float.value
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_powered then
       _data.truckProperties.wheels[buf^.index].powered := buf^.value.value_bool.value = 1
     else
     if buf^.name = SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_liftable then
       _data.truckProperties.wheels[buf^.index].liftable := buf^.value.value_bool.value = 1;

     inc(buf);
   end;
end;

procedure configuration_event(const event: scs_event_t; const event_info: pointer; const context: scs_context_t ); cdecl;
var cfg: pscs_telemetry_configuration_t;
begin
  if event_info <> nil then
    begin
      cfg := event_info;
      if cfg^.id = SCS_TELEMETRY_CONFIG_truck then
       begin
         eut2Data.params.common.log(SCS_LOG_TYPE_message, cfg^.id);
         print_attributes(cfg^.attributes);
         fillTruckProperties(cfg^.attributes, context);
       end;
    end;
end;

function scs_telemetry_init (const version: scs_u32_t; const params: pscs_telemetry_init_params_t): scs_result_t; cdecl;
begin
  eut2Data := TEUT2Data.Create(params^);
  params^.common.log(SCS_LOG_TYPE_message, 'scs_telemetry_init');
  params^.register_for_event(SCS_TELEMETRY_EVENT_configuration, @configuration_event, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_speed), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_engine_rpm), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_engine_gear), SCS_U32_NIL, SCS_VALUE_TYPE_s32, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_s32, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_cruise_control), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_brake_temperature), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_fuel), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_fuel_average_consumption), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_fuel_range), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_adblue), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_adblue_average_consumption), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_oil_pressure), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_oil_temperature), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_water_temperature), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_battery_voltage), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);

  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_wear_engine), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_wear_transmission), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_wear_cabin), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_wear_chassis), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_wear_wheels), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_odometer), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_navigation_distance), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_navigation_time), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_navigation_speed_limit), SCS_U32_NIL, SCS_VALUE_TYPE_float, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_float, eut2Data);


  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_parking_brake), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_motor_brake), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure_warning), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure_emergency), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_fuel_warning), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_adblue_warning), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_oil_pressure_warning), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_water_temperature_warning), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_battery_voltage_warning), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_electric_enabled), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_engine_enabled), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_lblinker), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_rblinker), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_lblinker), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_rblinker), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_parking), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_low_beam), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_high_beam), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_aux_front), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_aux_roof), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_beacon), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_brake), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_light_reverse), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);
  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_wipers), SCS_U32_NIL, SCS_VALUE_TYPE_bool, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_bool, eut2Data);

  params^.register_for_channel(scs_string_t(SCS_TELEMETRY_TRUCK_CHANNEL_retarder_level), SCS_U32_NIL, SCS_VALUE_TYPE_s32, SCS_TELEMETRY_CHANNEL_FLAG_none, @telemetry_store_u32, eut2Data);
  eut2Thread := TscsDataThread.Create(eut2Data);
  ser2Thread := TscsATSerialThread.Create(eut2Data);
  Result := SCS_RESULT_ok;
end;

procedure scs_telemetry_shutdown(); cdecl;
begin
  eut2Data.electricEnabled:=False;
  Sleep(1000);
  if Assigned(eut2Thread) then
   begin
     eut2Thread.Terminate;
     eut2Thread.WaitFor;
     FreeAndNil(eut2Thread);
   end;
  if Assigned(ser2Thread) then
   begin
     ser2Thread.Terminate;
     ser2Thread.WaitFor;
     FreeAndNil(ser2Thread);
   end;

  if Assigned(eut2Data) then
     FreeAndNil(eut2Data);

end;

exports
    scs_telemetry_init,
    scs_telemetry_shutdown;

begin
end.

