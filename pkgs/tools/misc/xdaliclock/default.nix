{ stdenv, fetchurl, libX11, xproto, libXt, libICE, libSM, libXext }:

stdenv.mkDerivation rec {
  name = "xdaliclock-${version}";
  version = "2.43";

  src = fetchurl {
    url="http://www.jwz.org/xdaliclock/${name}.tar.gz";
    sha256 = "194zzp1a989k2v8qzfr81gdknr8xiz16d6fdl63jx9r3mj5klmvb";
  };

  # Note: don't change this to set sourceRoot, or updateAutotoolsGnuConfigScriptsHook
  # on aarch64 doesn't find the files to patch and the aarch64 build fails!
  preConfigure = "cd X11";

  buildInputs = [ libX11 xproto libXt libICE libSM libXext ];

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
