{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pcm";
  version = "202110";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "sha256-YcTsC1ceCXKALroyZtgRYpqK3ysJhgzRJ8fBiCx7CCM=";
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
