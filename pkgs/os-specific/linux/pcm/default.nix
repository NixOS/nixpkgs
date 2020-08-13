{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "202007";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "1qqp51mvi52jvf6zf4g1fzv6nh9p37y0i7r2y273gwcdygbidzma";
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
