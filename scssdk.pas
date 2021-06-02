unit scssdk;

{$mode ObjFPC}{$H+}
{$i scssdk.inc}

interface
uses
    ctypes;
type
    scs_u8_t = cuint8;
    scs_u16_t = cuint16;
    scs_s32_t = cint32;
    scs_u32_t = cuint32;
    scs_u64_t = cuint64;
    scs_s64_t = cint64;
    scs_float_t = cfloat;
    scs_double_t = cdouble;
    scs_string_t = PChar;


const SCS_U32_NIL: scs_u32_t = (-1);
type
    scs_context_t = Pointer;
    scs_timestamp_t = scs_u64_t;
    scs_result_t = scs_s32_t;

const SCS_RESULT_ok: scs_result_t                        =  0; // Operation succeeded.
const SCS_RESULT_unsupported: scs_result_t               = -1; // Operation or specified parameters are not supported. (e.g. the plugin does not support the requested version of the API)
const SCS_RESULT_invalid_parameter: scs_result_t         = -2; // Specified parameter is not valid (e.g. null value of callback, invalid combination of flags).
const SCS_RESULT_already_registered: scs_result_t        = -3; // There is already a registered callback for the specified function (e.g. event/channel).
const SCS_RESULT_not_found: scs_result_t                 = -4; // Specified item (e.g. channel) was not found.
const SCS_RESULT_unsupported_type: scs_result_t          = -5; // Specified value type is not supported (e.g. channel does not provide that value type).
const SCS_RESULT_not_now: scs_result_t                   = -6; // Action (event/callback registration) is not allowed in the current state. Indicates incorrect use of the api.
const SCS_RESULT_generic_error: scs_result_t             = -7; // Error not covered by other existing code.

type
    scs_log_type_t = scs_s32_t;
const SCS_LOG_TYPE_message: scs_log_type_t       = 0;
const SCS_LOG_TYPE_warning: scs_log_type_t       = 1;
const SCS_LOG_TYPE_error: scs_log_type_t         = 2;

function SCS_MAKE_VERSION(major, minor: scs_u16_t): scs_u32_t; inline;
function SCS_GET_MAJOR_VERSION(version: scs_u32_t): scs_u16_t; inline;
function SCS_GET_MINOR_VERSION(version: scs_u32_t): scs_u16_t; inline;

type
    scs_log_t = procedure(const &type: scs_log_type_t; const message: scs_string_t); cdecl;
type
    scs_sdk_init_params_v100_t = record

            (**
             * @brief Name of the game for display purposes.
             *
             * This is UTF8 encoded string containing name of the game
             * for display to the user. The exact format is not defined,
             * might be changed between versions and should be not parsed.
             *
             * This pointer will be never NULL.
             *)
            game_name: scs_string_t;

            (**
             * @brief Identification of the game.
             *
             * If the library wants to identify the game to do any
             * per-game configuration, this is the field which should
             * be used.
             *
             * This string contains only following characters:
             * @li lower-cased letters
             * @li digits
             * @li underscore
             *
             * This pointer will be never NULL.
             *)
            game_id: scs_string_t;

            (**
             * @brief Version of the game for purpose of the specific api
             * which is being initialized.
             *
             * Does NOT match the patch level of the game.
             *)
            game_version: scs_u32_t;

    {$ifdef SCS_ARCHITECTURE_x64}
            (**
             * @brief Explicit alignment for the 64 bit pointer.
             *)
            _padding: scs_u32_t;
    {$endif}

            (**
             * @brief Function used to write messages to the game log.
             *
             * Each message is printed on a separate line.
             *
             * This pointer will be never NULL.
             *)
            log: scs_log_t;
    end;

{$If defined(SCS_ARCHITECTURE_x86)}
 {$If sizeof(scs_sdk_init_params_v100_t) <> 16}
     // Size scs_sdk_init_params_v100_t wrong!
 {$EndIf}
{$ElseIf defined(SCS_ARCHITECTURE_X64)}
  {$If sizeof(scs_sdk_init_params_v100_t) <> 32}
     // Size scs_sdk_init_params_v100_t wrong!
  {$EndIf}
{$EndIf}

{$define SCS_TELEMETRY_VERSION_1_00 := SCS_MAKE_VERSION(1, 0)}
{$define SCS_TELEMETRY_VERSION_1_01 := SCS_MAKE_VERSION(1, 1)}
{$define SCS_TELEMETRY_VERSION_CURRENT := SCS_TELEMETRY_VERSION_1_01}


implementation

function SCS_MAKE_VERSION(major, minor: scs_u16_t): scs_u32_t; inline;
begin
  result := (major shl 16) or minor;
end;

function SCS_GET_MAJOR_VERSION(version: scs_u32_t): scs_u16_t; inline;
begin
  result := version shr 16;
end;

function SCS_GET_MINOR_VERSION(version: scs_u32_t): scs_u16_t; inline;
begin
 Result := version and $FFFF;
end;

end.

