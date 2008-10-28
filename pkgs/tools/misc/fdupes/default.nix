{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fdupes-1.40";
  src = fetchurl {
    url = http://premium.caribe.net/~adrian2/programs/fdupes-1.40.tar.gz;
    sha256 = "1ryxpckgrmqa4y7nx9a9xpg4z1r00k11kc1cm7lqv87l9g293vg1";
  };

  installPhase =  ''
    mkdir -p $out/{bin,man/man1}
    make INSTALLDIR=$out/bin MANPAGEDIR=$out/man install
  '';

  meta = {
    description = "identifies duplicate files residing within specified directories.";
    longDescription = ''
      FDUPES uses md5sums and then a byte by byte comparison to finde duplicate
      files within a set of directories.
    '';
    homepage = http://premium.caribe.net/~adrian2/fdupes.html;
    license = "MIT";
  };
}
