{ lib, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "rocm-smi";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROC-smi";
    rev = "rocm-${version}";
    sha256 = "189mpvmcv46nfwshyc1wla6k71kbraldik5an20g4v9s13ycrpx9";
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
