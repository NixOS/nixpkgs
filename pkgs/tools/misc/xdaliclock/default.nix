{ stdenv, fetchurl, libX11, xorgproto, libXt, libICE, libSM, libXext }:

stdenv.mkDerivation rec {
  name = "xdaliclock-${version}";
  version = "2.44";

  src = fetchurl {
    url="https://www.jwz.org/xdaliclock/${name}.tar.gz";
    sha256 = "1gsgnsm6ql0mcg9zpdkhws3g23r3a92bc3rpg4qbgbmd02nvj3c0";
  };

  # Note: don't change this to set sourceRoot, or updateAutotoolsGnuConfigScriptsHook
  # on aarch64 doesn't find the files to patch and the aarch64 build fails!
  preConfigure = "cd X11";

  buildInputs = [ libX11 xorgproto libXt libICE libSM libXext ];

  preInstall = ''
    mkdir -vp $out/bin $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "A clock application that morphs digits when they are changed";
    maintainers = with maintainers; [ raskin rycee ];
    platforms = with platforms; linux ++ freebsd;
    license = licenses.free; #TODO BSD on Gentoo, looks like MIT
    downloadPage = http://www.jwz.org/xdaliclock/;
  };
}
