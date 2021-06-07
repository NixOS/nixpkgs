{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "202101";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "sha256-xiC9XDuFcAzD2lVuzBWUvHy1Z1shEXM2KPFabKvgh1Y=";
  };

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
