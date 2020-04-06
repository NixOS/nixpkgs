{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "202003";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "1f83dhzrzgcyv5j5xxibvywvpg8sgf1g72f5x40cdb4149nwbfra";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp pcm*.x $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
}
