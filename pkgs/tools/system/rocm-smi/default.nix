{ lib, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "rocm-smi";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROC-smi";
    rev = "rocm-${version}";
    sha256 = "00g9cbni73x9da05lx7hiffp303mdkj1wpxiavfylr4q4z84yhrz";
  };

  format = "other";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dm0755 rocm_smi.py $out/bin/rocm-smi
  '';

  meta = with lib; {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/RadeonOpenCompute/ROC-smi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
