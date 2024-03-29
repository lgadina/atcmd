(**
 * @file scssdk_telemetry_job_common_channels.h
 *
 * @brief Job telemetry specific constants for channels.
 *)
{$ifndef SCSSDK_TELEMETRY_JOB_COMMON_CHANNELS_H}
{$define SCSSDK_TELEMETRY_JOB_COMMON_CHANNELS_H}

{$i '../scssdk.inc'}


(**
 * @brief The total damage of the cargo in range 0.0 to 1.0.
 *
 * Type: float
 *)
{$define SCS_TELEMETRY_JOB_CHANNEL_cargo_damage                  := 'job.cargo.damage'}

{$endif} // SCSSDK_TELEMETRY_JOB_COMMON_CHANNELS_H

