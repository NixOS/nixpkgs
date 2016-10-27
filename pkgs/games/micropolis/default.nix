{ stdenv, fetchurl, libX11, libXpm, libXext, xextproto, byacc }:

stdenv.mkDerivation {
  name = "micropolis-2010-12-18"; # version from the patch timestamp

  src = fetchurl {
    url = http://www.donhopkins.com/home/micropolis/micropolis-activity-source.tgz;
    sha256 = "1b3c72dc3680a34b5fc5a740a6fb5cfc0b8775514da8ab7bb3b2965b20d4f8bc";
  };

  patches =
    [ (fetchurl {
        url = http://rmdir.de/~michael/micropolis_git.patch;
        sha256 = "0sjl61av7lab3a5vif1jpyicmdb2igvqq6nwaw0s3agg6dh69v1d";
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
