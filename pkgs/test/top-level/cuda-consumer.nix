{
  cuda_nvcc,
  cuda_cudart,
  stdenv,
  label ? "default",
}:
stdenv.mkDerivation {
  name = "cuda-scope-consumer-${label}";
  nativeBuildInputs = [ cuda_nvcc ];
  buildInputs = [ cuda_cudart ];
  buildCommand = "touch $out";
}
