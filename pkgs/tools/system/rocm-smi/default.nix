{ lib, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "rocm-smi";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROC-smi";
    rev = "rocm-${version}";
    sha256 = "190x31s7mjpyp7hr6cgdnvn2s20qj3sqcxywycjm2i9ar429l2ni";
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
