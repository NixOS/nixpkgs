{ lib, stdenv, autoPatchelfHook, dpkg, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hp-ams";
  version = "2.8.3";

  src = fetchurl {
    url = "http://downloads.linux.hpe.com/SDR/repo/mcp/debian/pool/non-free/hp-ams_2.8.3-3056.1ubuntu16_amd64.deb";
    sha256 = "sha256-6EwGC1IsMX1/aN/Qp2+NK+dvyXYsZXsm8E3uHfQSXik=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
  '';

  meta = with lib; {
    description = "HP Agentless Management Service for ProLiant";
    homepage = "https://buy.hpe.com/uk/en/software/server-management-software/server-ilo-management/ilo-management-engine/hpe-agentless-management/p/5219980";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ citadelcore ];
  };
}
