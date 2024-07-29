{ lib, stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xilinx-bootgen";
  version = "xilinx_v2024.1";

  src = fetchFromGitHub {
    owner = "xilinx";
    repo = "bootgen";
    rev = finalAttrs.version;
    hash = "sha256-/gNAqjwfaD2NWxs2536XGv8g2IyRcQRHzgLcnCr4a34=";
  };

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 bootgen $out/bin/bootgen
  '';

  meta = with lib; {
    description = "Generate Boot Images for Xilinx Zynq and ZU+ SoCs";
    longDescription = ''
      Bootgen for Xilinx Zynq and ZU+ SoCs, without code related to generating
      obfuscated key and without code to support FPGA encryption and
      authentication. These features are only available as part of Bootgen
      shipped with Vivado tools.

      For more details about Bootgen, please refer to Xilinx UG1283.
    '';
    homepage = "https://github.com/Xilinx/bootgen";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.flokli ];
    mainProgram = "bootgen";
  };
})
