{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation {
  pname = "xilinx-bootgen";
  version = "unstable-2019-10-23";

  src = fetchFromGitHub {
    owner = "xilinx";
    repo = "bootgen";
    rev = "f9f477adf243fa40bc8c7316a7aac37a0efd426d";
    sha256 = "1qciz3jkzy0z0lcgqnhch9pqj0202mk5ghzp2m9as5pzk8n8hrbz";
  };

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 bootgen $out/bin/bootgen
  '';

  meta = with stdenv.lib; {
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
  };
}
