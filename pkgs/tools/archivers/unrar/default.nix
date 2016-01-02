{stdenv, fetchurl}:

let
  version = "5.2.7";
in
stdenv.mkDerivation {
  name = "unrar-${version}";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "1b1ggrqn020pvvh2ia98alqxpl1q3x65cb6zzqwv91rpjiz7a57g";
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
