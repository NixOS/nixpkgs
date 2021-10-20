{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "202107";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "sha256-2fN+jS6+BpodjjN+TV67uiNgZ0eblWjzbyU3CDp9ee0=";
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
