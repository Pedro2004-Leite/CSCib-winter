/*
 * L02.c
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
#include "L02_dt.h"

/* options for Simulink Desktop Real-Time board 0 */
static double RTWinBoardOptions0[] = {
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
};

/* list of Simulink Desktop Real-Time timers */
const int RTWinTimerCount = 1;
const double RTWinTimers[2] = {
  0.001, 0.0,
};

/* list of Simulink Desktop Real-Time boards */
const int RTWinBoardCount = 1;
RTWINBOARD RTWinBoards[1] = {
  { "National_Instruments/PCI-6221", 4294967295U, 5, RTWinBoardOptions0 },
};

/* Block signals (auto storage) */
B_L02_T L02_B;

/* Block states (auto storage) */
DW_L02_T L02_DW;

/* Real-time model */
RT_MODEL_L02_T L02_M_;
RT_MODEL_L02_T *const L02_M = &L02_M_;

/* Model output function */
void L02_output(void)
{
  /* local block i/o variables */
  real_T rtb_Potenciometer;
  real_T currentTime;

  /* Step: '<Root>/Step' */
  currentTime = L02_M->Timing.t[0];
  if (currentTime < L02_P.Step_Time) {
    L02_B.Step = L02_P.Step_Y0;
  } else {
    L02_B.Step = L02_P.Step_YFinal;
  }

  /* End of Step: '<Root>/Step' */
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) L02_P.AnalogOutput_RangeMode;
      parm.rangeidx = L02_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1, &L02_P.AnalogOutput_Channels,
                     &L02_B.Step, &parm);
    }
  }

  /* S-Function Block: <Root>/	Potenciometer  */
  {
    ANALOGIOPARM parm;
    parm.mode = (RANGEMODE) L02_P.Potenciometer_RangeMode;
    parm.rangeidx = L02_P.Potenciometer_VoltRange;
    RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1, &L02_P.Potenciometer_Channels,
                   &rtb_Potenciometer, &parm);
  }

  /* S-Function Block: <Root>/Gauge  */
  {
    ANALOGIOPARM parm;
    parm.mode = (RANGEMODE) L02_P.Gauge_RangeMode;
    parm.rangeidx = L02_P.Gauge_VoltRange;
    RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1, &L02_P.Gauge_Channels,
                   &L02_B.Gauge, &parm);
  }
}

/* Model update function */
void L02_update(void)
{
  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++L02_M->Timing.clockTick0)) {
    ++L02_M->Timing.clockTickH0;
  }

  L02_M->Timing.t[0] = L02_M->Timing.clockTick0 * L02_M->Timing.stepSize0 +
    L02_M->Timing.clockTickH0 * L02_M->Timing.stepSize0 * 4294967296.0;

  {
    /* Update absolute timer for sample time: [0.001s, 0.0s] */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick1"
     * and "Timing.stepSize1". Size of "clockTick1" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick1 and the high bits
     * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++L02_M->Timing.clockTick1)) {
      ++L02_M->Timing.clockTickH1;
    }

    L02_M->Timing.t[1] = L02_M->Timing.clockTick1 * L02_M->Timing.stepSize1 +
      L02_M->Timing.clockTickH1 * L02_M->Timing.stepSize1 * 4294967296.0;
  }
}

/* Model initialize function */
void L02_initialize(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) L02_P.AnalogOutput_RangeMode;
      parm.rangeidx = L02_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1, &L02_P.AnalogOutput_Channels,
                     &L02_P.AnalogOutput_InitialValue, &parm);
    }
  }
}

/* Model terminate function */
void L02_terminate(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) L02_P.AnalogOutput_RangeMode;
      parm.rangeidx = L02_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1, &L02_P.AnalogOutput_Channels,
                     &L02_P.AnalogOutput_FinalValue, &parm);
    }
  }
}

/*========================================================================*
 * Start of Classic call interface                                        *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  L02_output();
  UNUSED_PARAMETER(tid);
}

void MdlUpdate(int_T tid)
{
  L02_update();
  UNUSED_PARAMETER(tid);
}

void MdlInitializeSizes(void)
{
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
}

void MdlStart(void)
{
  L02_initialize();
}

void MdlTerminate(void)
{
  L02_terminate();
}

/* Registration function */
RT_MODEL_L02_T *L02(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)L02_M, 0,
                sizeof(RT_MODEL_L02_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&L02_M->solverInfo, &L02_M->Timing.simTimeStep);
    rtsiSetTPtr(&L02_M->solverInfo, &rtmGetTPtr(L02_M));
    rtsiSetStepSizePtr(&L02_M->solverInfo, &L02_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&L02_M->solverInfo, (&rtmGetErrorStatus(L02_M)));
    rtsiSetRTModelPtr(&L02_M->solverInfo, L02_M);
  }

  rtsiSetSimTimeStep(&L02_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&L02_M->solverInfo,"FixedStepDiscrete");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = L02_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mdlTsMap[1] = 1;
    L02_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    L02_M->Timing.sampleTimes = (&L02_M->Timing.sampleTimesArray[0]);
    L02_M->Timing.offsetTimes = (&L02_M->Timing.offsetTimesArray[0]);

    /* task periods */
    L02_M->Timing.sampleTimes[0] = (0.0);
    L02_M->Timing.sampleTimes[1] = (0.001);

    /* task offsets */
    L02_M->Timing.offsetTimes[0] = (0.0);
    L02_M->Timing.offsetTimes[1] = (0.0);
  }

  rtmSetTPtr(L02_M, &L02_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = L02_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    mdlSampleHits[1] = 1;
    L02_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(L02_M, 600.0);
  L02_M->Timing.stepSize0 = 0.001;
  L02_M->Timing.stepSize1 = 0.001;

  /* External mode info */
  L02_M->Sizes.checksums[0] = (2872336500U);
  L02_M->Sizes.checksums[1] = (1008655543U);
  L02_M->Sizes.checksums[2] = (3341700271U);
  L02_M->Sizes.checksums[3] = (4283972835U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    L02_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(L02_M->extModeInfo,
      &L02_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(L02_M->extModeInfo, L02_M->Sizes.checksums);
    rteiSetTPtr(L02_M->extModeInfo, rtmGetTPtr(L02_M));
  }

  L02_M->solverInfoPtr = (&L02_M->solverInfo);
  L02_M->Timing.stepSize = (0.001);
  rtsiSetFixedStepSize(&L02_M->solverInfo, 0.001);
  rtsiSetSolverMode(&L02_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  L02_M->ModelData.blockIO = ((void *) &L02_B);
  (void) memset(((void *) &L02_B), 0,
                sizeof(B_L02_T));

  /* parameters */
  L02_M->ModelData.defaultParam = ((real_T *)&L02_P);

  /* states (dwork) */
  L02_M->ModelData.dwork = ((void *) &L02_DW);
  (void) memset((void *)&L02_DW, 0,
                sizeof(DW_L02_T));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    L02_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Initialize Sizes */
  L02_M->Sizes.numContStates = (0);    /* Number of continuous states */
  L02_M->Sizes.numY = (0);             /* Number of model outputs */
  L02_M->Sizes.numU = (0);             /* Number of model inputs */
  L02_M->Sizes.sysDirFeedThru = (0);   /* The model is not direct feedthrough */
  L02_M->Sizes.numSampTimes = (2);     /* Number of sample times */
  L02_M->Sizes.numBlocks = (6);        /* Number of blocks */
  L02_M->Sizes.numBlockIO = (2);       /* Number of block outputs */
  L02_M->Sizes.numBlockPrms = (20);    /* Sum of parameter "widths" */
  return L02_M;
}

/*========================================================================*
 * End of Classic call interface                                          *
 *========================================================================*/
