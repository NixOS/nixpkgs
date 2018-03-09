{ stdenv, fetchurl, libX11, libXpm, libXext, xextproto, byacc }:

stdenv.mkDerivation {
  name = "micropolis-20100418"; # version from the patch timestamp

  src = fetchurl {
    url = http://www.donhopkins.com/home/micropolis/micropolis-activity-source.tgz;
    sha256 = "1g7qshh5p5mjndxspa2da5sqf2zwbkxsch57qmglp8w06vf74g0v";
  };

  patches =
    [ (fetchurl {
        url = http://rmdir.de/~michael/micropolis_git.patch;
        sha256 = "10j0svcs576ip7v5mn99gvqx9ki8jfd5w5yvsxj57xh56dd0by2p";
      })
    ];

  buildInputs = [ libX11 libXpm libXext xextproto byacc ];

  preConfigure =
    ''
      cd src
      sed -i "s@^CFLAGS.*\$@&\nCFLAGS += -I${libXpm.dev}/include/X11@" tk/makefile
      sed -i "s@^INCLUDES.*\$@&\n\t-I$PWD/tcl \\\\@" sim/makefile
    '';

  postInstall =
    ''
      mkdir -p $out/bin
      mkdir -p $out/usr/share/games/micropolis
      cd ..
      for d in activity cities images manual res; do
        cp -R $d $out/usr/share/games/micropolis
      done
      cp Micropolis $out/usr/share/games/micropolis
      cat > $out/bin/micropolis << EOF
      #!${stdenv.shell}
      cd $out/usr/share/games/micropolis
      ./Micropolis
      EOF
      chmod 755 $out/bin/micropolis
    '';

  meta = {
    description = "GPL'ed version of S*m C*ty";
    homepage = http://www.donhopkins.com/home/micropolis/;
    license = "GPL";
  };
}
