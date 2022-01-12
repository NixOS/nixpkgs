{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pcm";
  version = "202112";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "sha256-uuQvj8BcUmuYDwV4r3oqkT+QTcSFcGjBeGUM2NZRFcA=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp pcm*.x $out/bin
  '';

  meta = with lib; {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
}
