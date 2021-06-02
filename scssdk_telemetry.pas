unit scssdk_telemetry;

{$mode ObjFPC}{$H+}
{$i scssdk.inc}

interface

uses
  scssdk, scssdk_value, scssdk_telemetry_event, scssdk_telemetry_channel;

(**
 * @brief Common ancestor to all structures providing parameters to the telemetry
 * initialization.
 *)
(*type
    scs_telemetry_init_params_t = record
       method_indicating_this_is_not_a_c_struct: pointer;
    end;*)
(**
 * @brief Initialization parameters for the 1.00 version of the telemetry API.
 *)
type
    scs_telemetry_init_params_v100_t = record
        (**
         * @brief Common initialization parameters.
         *)
        common: scs_sdk_init_params_v100_t;

        (**
         * @name Functions used to handle registration of event callbacks.
         *)
        //@{
        register_for_event: scs_telemetry_register_for_event_t;
        unregister_from_event: scs_telemetry_unregister_from_event_t;
        //@}

        (**
         * @name Functions used to handle registration of telemetry callbacks.
         *)
        //@{
        register_for_channel: scs_telemetry_register_for_channel_t;
        unregister_from_channel: scs_telemetry_unregister_from_channel_t;
        //@}
    end;

scs_telemetry_init_params_t = scs_telemetry_init_params_v100_t;
pscs_telemetry_init_params_t = ^scs_telemetry_init_params_t;

{$if defined(SCS_ARCHITECTURE_x64)}
     {$If sizeof(scs_telemetry_init_params_v100_t) <> 64}
          //Error!
     {$EndIf}
{$ElseIf defined(SCS_ARCHITECTURE_x86)}
     {$If sizeof(scs_telemetry_init_params_v100_t) <> 32}
          Error!
     {$EndIf}
{$EndIf}


(**
 * @brief Initialization parameters for the 1.01 version of the telemetry API.
 *)
type
    scs_telemetry_init_params_v101_t = scs_telemetry_init_params_v100_t;

// Functions which should be exported by the dynamic library serving as
// recipient of the telemetry.

(**
 * @brief Initializes telemetry support.
 *
 * This function must be provided by the library if it wants to support telemetry API.
 *
 * The engine will call this function with API versions it supports starting from the latest
 * until the function returns SCS_RESULT_ok or error other than SCS_RESULT_unsupported or it
 * runs out of supported versions.
 *
 * At the time this function is called, the telemetry is in the paused state.
 *
 * @param version Version of the API to initialize.
 * @param params Structure with additional initialization data specific to the specified API version.
 * @return SCS_RESULT_ok if version is supported and library was initialized. Error code otherwise.
 *)
(*
type
SCSAPI_RESULT scs_telemetry_init (const scs_u32_t version, const params: pscs_telemetry_init_params_t); cdecl;

(**
 * @brief Shuts down the telemetry support.
 *
 * The engine will call this function if available and if the scs_telemetry_init indicated
 * success.
 *)
SCSAPI_VOID     scs_telemetry_shutdown          (void);
*)

implementation

end.

