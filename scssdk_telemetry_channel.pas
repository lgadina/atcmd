unit scssdk_telemetry_channel;

{$mode ObjFPC}{$H+}
{$i scssdk.inc}

interface

uses
  scssdk, scssdk_telemetry_event, scssdk_value;

(**
 * @name Telemetry channel flags.
 *)
//@{

(**
 * @brief No specific flags.
 *)
const SCS_TELEMETRY_CHANNEL_FLAG_none: scs_u32_t          = $00000000;

(**
 * @brief Call the callback even if the value did not change.
 *
 * The default behavior is to only call the callback if the
 * value changes. Note that there might be some special situations
 * where the callback might be called even if the value did not
 * change and this flag is not present. For example when the
 * provider of the channel value is reconfigured or when the value
 * changes so frequently that filtering would be only waste of time.
 *
 * Note that even this flag does not guarantee that the
 * callback will be called. For example it might be not called
 * when the value is currently unavailable and the
 * SCS_TELEMETRY_CHANNEL_FLAG_no_value flag was not provided.
 *)
const SCS_TELEMETRY_CHANNEL_FLAG_each_frame: scs_u32_t    = $00000001;

(**
 * @brief Call the callback even if the value is currently
 * unavailable.
 *
 * By default the callback is only called when the value is
 * available. If this flag is specified, the callback will be
 * called even when the value is unavailable. In that case
 * the value parameter of the callback will be set to NULL.
 *)
const SCS_TELEMETRY_CHANNEL_FLAG_no_value: scs_u32_t      = $00000002;

//@}

(**
 * @brief Type of function registered to be called with value of single telemetry channel.
 *
 * @param name Name of the channel. Intended for debugging purposes only.
 * @param index Index of entry for array-like channels.
 * @param value Current value of the channel. Will use the type provided during the registration.
 *        Will be NULL if and only if the SCS_TELEMETRY_CHANNEL_FLAG_no_value flag was specified
 *        during registration and the value is currently unavailable.
 * @param context Context information passed during callback registration.
 *)
type
    scs_telemetry_channel_callback_t = procedure(const name: scs_string_t; const index: scs_u32_t; const value: pscs_value_t; const context: scs_context_t); cdecl;

(**
 * @brief Registers callback to be called with value of specified telemetry channel.
 *
 * At most one callback can be registered for each combination of channel name, index and type.
 *
 * Note that order in which the registered callbacks are called is undefined.
 *
 * This funtion can be called from scs_telemetry_init or from within any
 * event (NOT channel) callback.
 *
 * @param name Name of channel to register to.
 * @param index Index of entry for array-like channels. Set to SCS_U32_NIL for normal channels.
 * @param type Desired type of the value. Only some types are supported (see documentation of specific channel). If the channel can not be returned using that type a SCS_RESULT_unsupported_type will be returned.
 * @param flags Flags controlling delivery of the channel.
 * @param callback Callback to register.
 * @param context Context value passed to the callback.
 * @return SCS_RESULT_ok on successful registration. Error code otherwise.
 *)
type
    scs_telemetry_register_for_channel_t = procedure(const name: scs_string_t; const index: scs_u32_t; const &type: scs_value_type_t; const flags: scs_u32_t; const callback: scs_telemetry_channel_callback_t; const context: scs_context_t); cdecl;

(**
 * @brief Unregisters callback registered for specified telemetry channel.
 *
 * This function can be called from scs_telemetry_shutdown, scs_telemetry_init
 * or from within any event (NOT channel) callback. Any channel left registered
 * after scs_telemetry_shutdown ends will be unregistered automatically.
 *
 * @param name Name of channel to register from.
 * @param index Index of entry for array-like channels. Set to SCS_U32_NIL for normal channels.
 * @param type Type of value to unregister from.
 * @return SCS_RESULT_ok on successful unregistration. Error code otherwise.
 *)
type
    scs_telemetry_unregister_from_channel_t = procedure(const name: scs_string_t; const index: scs_u32_t; const &type: scs_value_type_t); cdecl;



implementation

end.

