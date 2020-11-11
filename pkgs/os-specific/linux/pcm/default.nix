{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "202010";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "00i7bp7hqwnphh7qyjydvz5s14ydj8rwivz995bdnd37582dyij9";
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
