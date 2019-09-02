{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "201902";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = "${version}";
    sha256 = "15kh5ry2w1zj2mbg98hlayw8g53jy79q2ixj2wm48g8vagamv77z";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp pcm*.x $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Processor counter monitor";
    homepage = https://www.intel.com/software/pcm;
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
}
