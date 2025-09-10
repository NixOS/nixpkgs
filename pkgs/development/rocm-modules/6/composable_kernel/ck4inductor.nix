{
  buildPythonPackage,
  python,
  composable_kernel,
  lib,
  setuptools,
  setuptools-scm,
  rocm-merged-llvm,
}:
buildPythonPackage {
  pyproject = true;
  pname = "ck4inductor";
  build-system = [
    setuptools
    setuptools-scm
  ];
  version = "6.4.0";
  inherit (composable_kernel) src;
  pythonImportsCheck = [
    "ck4inductor"
    "ck4inductor.universal_gemm.gen_instances"
    "ck4inductor.universal_gemm.gen_instances"
    "ck4inductor.universal_gemm.op"
  ];
  propagatedBuildInputs = [
    # At runtime will fail to compile anything with ck4inductor without this
    # can't easily use in checks phase because most of the compiler machinery is in torch
    rocm-merged-llvm
  ];
  checkPhase = ''
    if [ ! -d "$out/${python.sitePackages}/ck4inductor" ]; then
      echo "ck4inductor isn't at the expected location in $out/${python.sitePackages}/ck4inductor"
      exit 1
    fi
  '';
  meta = with lib; {
    description = "Pytorch inductor backend which uses composable_kernel universal GEMM implementations";
    homepage = "https://github.com/ROCm/composable_kernel";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
}
