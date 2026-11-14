#ifndef WRAPPER_POLICY
#error "wrapper defaults are missing"
#endif
#if WRAPPER_POLICY != EXPECTED_POLICY
#error "the wrong wrapper supplied the defaults"
#endif
#ifndef RAW_SEED
#define RAW_SEED 0
#endif
#if RAW_SEED != EXPECTED_RAW
#error "the caller's salted input changed"
#endif
#ifndef ROLE_SEED
#define ROLE_SEED 0
#endif
#if ROLE_SEED != EXPECTED_ROLE
#error "the wrong dependency role supplied the inputs"
#endif
