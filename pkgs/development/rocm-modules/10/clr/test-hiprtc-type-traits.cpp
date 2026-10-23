#include <hip/hip_runtime.h>
#include <hip/hiprtc.h>
#include <iostream>
#include <string>

#define CHECK_HIP(expr) do { \
  if ((expr) != hipSuccess) { \
    std::cerr << #expr << " failed" << std::endl; \
    return 1; \
  } \
} while(0)

#define CHECK_HIPRTC(expr) do { \
  hiprtcResult _res = (expr); \
  if (_res != HIPRTC_SUCCESS) { \
    std::cerr << #expr << " failed: " << hiprtcGetErrorString(_res) << std::endl; \
    hiprtcGetProgramLogSize(prog, &log_size); \
    if (log_size > 0) { \
      std::string log(log_size, '\0'); \
      hiprtcGetProgramLog(prog, log.data()); \
      std::cerr << "Compile log:\n" << log << std::endl; \
    } \
    return 1; \
  } \
} while(0)

static const char* kernelSource = R"(
  #include <type_traits>

  extern "C" __global__ void test_kernel(int* out) {
    static_assert(std::is_same<int, std::remove_const<const int>::type>::value,
                  "type_traits not working");
    out[0] = 5;
  }
)";

int main() {
  hiprtcProgram prog;
  size_t log_size = 0;
  CHECK_HIPRTC(hiprtcCreateProgram(&prog, kernelSource, "test.hip", 0, nullptr, nullptr));
  CHECK_HIPRTC(hiprtcCompileProgram(prog, 0, nullptr));

  size_t code_size;
  CHECK_HIPRTC(hiprtcGetCodeSize(prog, &code_size));
  std::string code(code_size, '\0');
  CHECK_HIPRTC(hiprtcGetCode(prog, code.data()));
  hiprtcDestroyProgram(&prog);

  hipModule_t module;
  hipFunction_t kernel;
  CHECK_HIP(hipModuleLoadData(&module, code.data()));
  CHECK_HIP(hipModuleGetFunction(&kernel, module, "test_kernel"));

  int* d_out;
  int h_out = 0;
  CHECK_HIP(hipMalloc(&d_out, sizeof(int)));
  void* args[] = { &d_out };
  CHECK_HIP(hipModuleLaunchKernel(kernel, 1, 1, 1, 1, 1, 1, 0, nullptr, args, nullptr));
  CHECK_HIP(hipMemcpy(&h_out, d_out, sizeof(int), hipMemcpyDeviceToHost));

  if (h_out != 5) {
    std::cerr << "Kernel output mismatch: expected 5, got " << h_out << std::endl;
    return 1;
  }

  std::cout << "HIPRTC type_traits test passed (output=" << h_out << ")" << std::endl;
  return 0;
}
