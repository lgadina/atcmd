unit scssdk_value;

{$mode ObjFPC}{$H+}
{$i scssdk.inc}

interface
uses scssdk;

type
  scs_value_type_t = scs_u32_t;

const SCS_VALUE_TYPE_INVALID: scs_value_type_t           = 0;
const SCS_VALUE_TYPE_bool: scs_value_type_t              = 1;
const SCS_VALUE_TYPE_s32: scs_value_type_t               = 2;
const SCS_VALUE_TYPE_u32: scs_value_type_t               = 3;
const SCS_VALUE_TYPE_u64: scs_value_type_t               = 4;
const SCS_VALUE_TYPE_float: scs_value_type_t             = 5;
const SCS_VALUE_TYPE_double: scs_value_type_t            = 6;
const SCS_VALUE_TYPE_fvector: scs_value_type_t           = 7;
const SCS_VALUE_TYPE_dvector: scs_value_type_t           = 8;
const SCS_VALUE_TYPE_euler: scs_value_type_t             = 9;
const SCS_VALUE_TYPE_fplacement: scs_value_type_t        = 10;
const SCS_VALUE_TYPE_dplacement: scs_value_type_t        = 11;
const SCS_VALUE_TYPE_string: scs_value_type_t            = 12;
const SCS_VALUE_TYPE_s64: scs_value_type_t               = 13;
const SCS_VALUE_TYPE_LAST: scs_value_type_t              = 13;

(**
 * @name Simple data types.
 *)
//@{
type
    scs_value_bool_t = record
        value: scs_u8_t; //< Nonzero value is true, zero false.
    end;

type
    scs_value_s32_t = record
        value: scs_s32_t;
    end;

type
    scs_value_u32_t = record
        value: scs_u32_t;
    end;


type
    scs_value_u64_t = record
        value: scs_u64_t;
    end;

type
    scs_value_s64_t = record
        value: scs_s64_t;
    end;

type
    scs_value_float_t = record
        value: scs_float_t;
    end;

type
    scs_value_double_t = record
        value: scs_double_t;
    end;
//@}

(**
 * @brief String value.
 *
 * The provided value is UTF8 encoded however in some documented
 * cases only limited ASCII compatible subset might be present.
 *
 * The pointer is never NULL.
 *)
type
    scs_value_string_t = record
        value: scs_string_t;
    end;

(**
 * @name Vector types.
 *
 * In local space the X points to right, Y up and Z backwards.
 * In world space the X points to east, Y up and Z south.
 *)
//@{
type
    scs_value_fvector_t = record
        x: scs_float_t;
        y: scs_float_t;
        z: scs_float_t;
    end;

type
    scs_value_dvector_t = record
        x: scs_double_t;
        y: scs_double_t;
        z: scs_double_t;
    end;
//@}

(**
 * @brief Orientation of object.
 *)
type
    scs_value_euler_t = record
        (**
         * @brief Heading.
         *
         * Stored in unit range where <0,1) corresponds to <0,360).
         *
         * The angle is measured counterclockwise in horizontal plane when looking
         * from top where 0 corresponds to forward (north), 0.25 to left (west),
         * 0.5 to backward (south) and 0.75 to right (east).
         *)
        heading: scs_float_t;

        (**
         * @brief Pitch
         *
         * Stored in unit range where <-0.25,0.25> corresponds to <-90,90>.
         *
         * The pitch angle is zero when in horizontal direction,
         * with positive values pointing up (0.25 directly to zenith),
         * and negative values pointing down (-0.25 directly to nadir).
         *)
         pitch: scs_float_t;

        (**
         * @brief Roll
         *
         * Stored in unit range where <-0.5,0.5> corresponds to <-180,180>.
         *
         * The angle is measured in counterclockwise when looking in direction of
         * the roll axis.
         *)
         roll: scs_float_t;
    end;

(**
 * @name Combination of position and orientation.
 *)
//@{
type
    scs_value_fplacement_t = record
        position: scs_value_fvector_t;
        orientation: scs_value_euler_t;
    end;

type
    scs_value_dplacement_t = record
        position: scs_value_dvector_t;
        orientation: scs_value_euler_t;
        _padding: scs_u32_t; // Explicit padding.
    end;
//@}

(**
 * @brief Varying type storage for values.
 *)
type
    scs_value_t = record
        (**
         * @brief Type of the value.
         *)
        &type: scs_value_type_t;

        (**
         * @brief Explicit alignment for the union.
         *)
        _padding: scs_u32_t;

        (**
         * @brief Storage.
         *)
        case byte of
                1:(value_bool: scs_value_bool_t);
                2:(value_s32: scs_value_s32_t);
                3:(value_u32: scs_value_u32_t);
                4:(value_u64: scs_value_u64_t);
                5:(value_s64: scs_value_s64_t);
                6:(value_float: scs_value_float_t);
                7:(value_double: scs_value_double_t);
                8:(value_fvector: scs_value_fvector_t);
                9:(value_dvector: scs_value_dvector_t);
                10:(value_euler: scs_value_euler_t);
                11:(value_fplacement: scs_value_fplacement_t);
                12:(value_dplacement: scs_value_dplacement_t);
                13:(value_string: scs_value_string_t);
    end;
    pscs_value_t = ^scs_value_t;

{$If sizeof(scs_value_s32_t) <> 4}
     //Error!
{$EndIf}

{$If sizeof(scs_value_u32_t) <> 4}
     //Error!
{$EndIf}

{$If sizeof(scs_value_u64_t) <> 8}
    //Error!
{$EndIf}

{$If sizeof(scs_value_s64_t) <> 8}
    //Error!
{$EndIf}

{$If sizeof(scs_value_float_t) <> 4}
    //Error!
{$EndIf}

{$If sizeof(scs_value_double_t) <> 8}
    //Error!
{$EndIf}

{$If sizeof(scs_value_fvector_t) <> 12}
    //Error!
{$EndIf}

{$If sizeof(scs_value_dvector_t) <> 24}
    //Error!
{$EndIf}
{$If sizeof(scs_value_fplacement_t) <> 24}
    //Error!
{$EndIf}

{$If sizeof(scs_value_dplacement_t) <> 40}
    //Error!
{$EndIf}

{$if defined(SCS_ARCHITECTURE_x64)}
     {$If sizeof(scs_value_string_t) <> 8}
          // Error!
     {$EndIf}
{$ElseIf defined(SCS_ARCHITECTURE_x86)}
     {$If sizeof(scs_value_string_t) <> 4}
          // Error!
     {$EndIf}
{$EndIf}

{$If sizeof(scs_value_t) <> 48}
    // Error!
{$EndIf}

(**
 * @brief Combination of value and its name.
 *)
type
    scs_named_value_t = record
        (**
         * @brief Name of this value.
         *
         * ASCII subset of UTF-8.
         *)
        name: scs_string_t;

        (**
         * @brief Zero-based index of the value for array-like values.
         *
         * For non-array values it is set to SCS_U32_NIL.
         *)
        index: scs_u32_t;

{$if defined(SCS_ARCHITECTURE_x64)}
        (**
         * @brief Explicit 8-byte alignment for the value part.
         *)
        _padding: scs_u32_t;
{$EndIf}

        (**
         * @brief The value itself.
         *)
        value: scs_value_t;
  end;
  pscs_named_value_t = ^scs_named_value_t;

{$if defined(SCS_ARCHITECTURE_x64)}
     {$If sizeof(scs_named_value_t) <> 64}
          // Error!
     {$EndIf}
{$ElseIf defined(SCS_ARCHITECTURE_x86)}
     {$If sizeof(scs_named_value_t) <> 56}
         // Error!
     {$EndIf}
{$EndIf}


implementation

end.

