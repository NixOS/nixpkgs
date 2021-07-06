{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "rocm-smi";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm_smi_lib";
    rev = "rocm-${version}";
    hash = "sha256-LEaC1XhmyoVWrpL05MhgN02LVT2rLKdnw9g2QdfM/uE=";
  };

  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

  postPatch = ''
    # Upstream ROCm is installed in an /opt directory. For this reason,
    # it does not completely follow FHS layout, creating top-level
    # rocm_smi, oam, and bindings top-level directories. Since rocm-smi
    # is a package that is typically installed, we change the paths to
    # follow FHS more closely.

    # rocm_smi libraries and headers go into lib and include. Bindings
    # go into lib/rocm_smi/bindings.
    substituteInPlace rocm_smi/CMakeLists.txt \
      --replace "DESTINATION rocm_smi/" "DESTINATION " \
      --replace "DESTINATION bindings" "DESTINATION lib/rocm_smi/bindings" \
      --replace "../rocm_smi/bindings/rsmiBindings.py" "../lib/rocm_smi/bindings/rsmiBindings.py" \
      --replace 'DESTINATION ''${ROCM_SMI}/' "DESTINATION "

    # oam libraries and headers go into lib and include.
    substituteInPlace oam/CMakeLists.txt \
      --replace "DESTINATION oam/" "DESTINATION " \
      --replace 'DESTINATION ''${OAM_NAME}/' "DESTINATION "

    # Update relative path to librocm_smi64 in the Python binding.
    substituteInPlace python_smi_tools/rsmiBindings.py \
      --replace "/../lib/librocm_smi64.so" "/../../librocm_smi64.so"
  '';

  postInstall = ''
    wrapPythonProgramsIn $out/bin
  '';

  meta = with lib; {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/RadeonOpenCompute/ROC-smi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
