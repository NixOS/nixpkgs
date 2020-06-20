{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  version = "2012-05-31";
  pname = "woof";

  src = fetchurl {
    url = "http://www.home.unix-ag.org/simon/woof-${version}.py";
    sha256 = "d84353d07f768321a1921a67193510bf292cf0213295e8c7689176f32e945572";
  };

  buildInputs = [ python ];

  dontUnpack = true;

  installPhase =
    ''
      mkdir -p $out/bin
      cp $src $out/bin/woof
      chmod +x $out/bin/woof
    '';

  meta = with stdenv.lib; {
    homepage = "http://www.home.unix-ag.org/simon/woof.html";
    description = "Web Offer One File - Command-line utility to easily exchange files over a local network";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ lschuermann ];
  };
}

