{ fetchurl, stdenv, unzip, python, alsaLib, libX11, mesa }:

stdenv.mkDerivation rec {
  name = "teeworlds-0.4.3";

  src = fetchurl {
    url = "http://www.teeworlds.com/files/${name}-src.tar.gz";
    sha256 = "1k141517wchhw2586m0kkvh65kadnlybpvzrxlb8b098jbg1hr1n";
  };

  # Note: Teeworlds requires Python 2.x to compile.  Python 3.0 will
  # not work.
  buildInputs = [ unzip python alsaLib libX11 mesa ];

  patchPhase = ''
    substituteInPlace "default.bam"                             \
      --replace 'settings.linker.flags = ""'                    \
                'settings.linker.flags = "-fstack-protector-all"'
  '';
  configurePhase = ''
    # Fetch and build BAM, the home-made build system.
    unzip ${fetchurl {
        url = "http://teeworlds.com/files/bam.zip";
        sha256 = "0dz9k906skgzc4l15ihlqb1d1hk0s2yajadbq5zs01gxi05xhy6v";
      }
    }
    ( cd bam && ./make_unix.sh )

    # Build Teeworlds.
    ./bam/src/bam release
  '';

  installPhase = ''
    # Copy the graphics, sounds, etc.
    ensureDir "$out/share/${name}"
    cp -rv data other/icons "$out/share/${name}"

    # Copy the executables (client, server, etc.).
    ensureDir "$out/bin"
    executables=""
    for file in *
    do
      if [ -f "$file" ] && [ -x "$file" ]
      then
          executables="$file $executables"
      fi
    done
    cp -v $executables "$out/bin"

    # Make sure the programs are executed from the right directory so
    # that they can access the graphics and sounds.
    for program in $executables
    do
      mv -v "$out/bin/$program" "$out/bin/.wrapped-$program"
      cat > "$out/bin/$program" <<EOF
#!/bin/sh
cd "$out/share/${name}" && exec "$out/bin/.wrapped-$program"
EOF
      chmod -v +x "$out/bin/$program"
    done

    # Copy the documentation.
    ensureDir "$out/doc/${name}"
    cp -v *.txt "$out/doc/${name}"
  '';

  meta = {
    description = "Teeworlds, a retro multiplayer shooter game";

    longDescription = ''
      Teeworlds is a free online multiplayer game, available for all
      major operating systems.  Battle with up to 12 players in a
      variety of game modes, including Team Deathmatch and Capture The
      Flag.  You can even design your own maps!
    '';

    homepage = http://teeworlds.com/;
    license = "BSD-style, see `license.txt'";
  };
}
