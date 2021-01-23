{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "202011";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "09p8drp9xvvs5bahgnr9xx6987fryz27xs2zaf1mr7a9wsh5j912";
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
