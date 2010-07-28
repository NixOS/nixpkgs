{ stdenv, fetchurl, libX11, libXpm, libXext, xextproto, byacc }:

stdenv.mkDerivation {
  name = "micropolis";

  src = fetchurl {
    url = http://www.donhopkins.com/home/micropolis/micropolis-activity-source.tgz;
    sha256 = "1b3c72dc3680a34b5fc5a740a6fb5cfc0b8775514da8ab7bb3b2965b20d4f8bc";
  };

  patches =
    [ (fetchurl {
        url = http://rmdir.de/~michael/micropolis_git.patch;
        sha256 = "13419a4394242cd11d5cabd8b1b50787282ea16b55fdcfbeadf8505af46b0592";
      })
    ];

  buildInputs = [ libX11 libXpm libXext xextproto byacc ];

  preConfigure =
    ''
      cd src
      sed -i "s@^CFLAGS.*\$@&\nCFLAGS += -I${libXpm}/include/X11@" tk/makefile
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
      #!/bin/bash
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
