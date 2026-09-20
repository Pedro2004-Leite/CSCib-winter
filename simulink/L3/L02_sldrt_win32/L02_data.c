/*
 * L02_data.c
 *
 * Code generation for model "L02".
 *
 * Model version              : 1.4
 * Simulink Coder version : 8.8 (R2015a) 09-Feb-2015
 * C source code generated on : Mon Sep 14 15:11:25 2026
 *
 * Target selection: rtwin.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86/Pentium
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "L02.h"
#include "L02_private.h"

/* Block parameters (auto storage) */
P_L02_T L02_P = {
  0.0,                                 /* Mask Parameter: AnalogOutput_FinalValue
                                        * Referenced by: '<Root>/Analog Output'
                                        */
  0.0,                                 /* Mask Parameter: AnalogOutput_InitialValue
                                        * Referenced by: '<Root>/Analog Output'
                                        */
  10.0,                                /* Mask Parameter: AnalogOutput_MaxMissedTicks
                                        * Referenced by: '<Root>/Analog Output'
                                        */
  10.0,                                /* Mask Parameter: Potenciometer_MaxMissedTicks
                                        * Referenced by: '<Root>/	Potenciometer '
                                        */
  10.0,                                /* Mask Parameter: Gauge_MaxMissedTicks
                                        * Referenced by: '<Root>/Gauge '
                                        */
  0.0,                                 /* Mask Parameter: AnalogOutput_YieldWhenWaiting
                                        * Referenced by: '<Root>/Analog Output'
                                        */
  0.0,                                 /* Mask Parameter: Potenciometer_YieldWhenWaiting
                                        * Referenced by: '<Root>/	Potenciometer '
                                        */
  0.0,                                 /* Mask Parameter: Gauge_YieldWhenWaiting
                                        * Referenced by: '<Root>/Gauge '
                                        */
  0,                                   /* Mask Parameter: AnalogOutput_Channels
                                        * Referenced by: '<Root>/Analog Output'
                                        */
  0,                                   /* Mask Parameter: Potenciometer_Channels
                                        * Referenced by: '<Root>/	Potenciometer '
                                        */
  1,                                   /* Mask Parameter: Gauge_Channels
                                        * Referenced by: '<Root>/Gauge '
                                        */
  0,                                   /* Mask Parameter: AnalogOutput_RangeMode
                                        * Referenced by: '<Root>/Analog Output'
                                        */
  0,                                   /* Mask Parameter: Potenciometer_RangeMode
                                        * Referenced by: '<Root>/	Potenciometer '
                                        */
  0,                                   /* Mask Parameter: Gauge_RangeMode
                                        * Referenced by: '<Root>/Gauge '
                                        */
  0,                                   /* Mask Parameter: AnalogOutput_VoltRange
                                        * Referenced by: '<Root>/Analog Output'
                                        */
  0,                                   /* Mask Parameter: Potenciometer_VoltRange
                                        * Referenced by: '<Root>/	Potenciometer '
                                        */
  0,                                   /* Mask Parameter: Gauge_VoltRange
                                        * Referenced by: '<Root>/Gauge '
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Step'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Step'
                                        */
  1.0                                  /* Expression: 1
                                        * Referenced by: '<Root>/Step'
                                        */
};
