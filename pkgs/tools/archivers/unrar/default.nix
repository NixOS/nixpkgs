{stdenv, fetchurl}:

let
  version = "5.3.9";
in
stdenv.mkDerivation {
  name = "unrar-${version}";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "0nsxwg1zp3s34wyjznwmy2cc5929yk7m5smq11cqdb6hmql3fngz";
  };

  preBuild = ''
    export buildFlags="CXX=$CXX"
  '';

  installPhase = ''
    installBin unrar

    mkdir -p $out/share/doc/unrar
    cp acknow.txt license.txt \
        $out/share/doc/unrar
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Utility for RAR archives";
    homepage = http://www.rarlab.com/;
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
