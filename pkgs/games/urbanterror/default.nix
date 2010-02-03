{ stdenv, fetchurl, unzip, SDL, mesa, curl, openal }:
stdenv.mkDerivation rec {
  name = "urbanterror-${version}";
  version = "4.1";
  src1 = fetchurl {
    url = "http://ftp.snt.utwente.nl/pub/games/urbanterror/UrbanTerror_41_FULL.zip";
    sha256 = "0pr6xpwq8zllc0xsdxl8cfd0zz5fhggw5fsbrizygr6hhdvra1jp";
  };
  src2 = fetchurl {
    url = "http://ftp.snt.utwente.nl/pub/games/urbanterror/iourbanterror/source/complete/ioUrbanTerrorSource_2007_12_20.zip";
    sha256 = "1s1wq9m7shhvvk7s4400yrmz7dys501i4c9ln1mglc9dhmi8dmcn";
  };
  unpackPhase = ''
    mkdir urbanterror
    cd urbanterror
    unzip $src1
    unzip $src2
  '';
  # FIXME
  #patchPhase = ''
  #  cd ioUrbanTerrorClientSource
  #  substituteInPlace code/client/snd_openal.c \
  #                    --replace libopenal.so.0 ${openal}/lib/libopenal.so
  #  substituteInPlace code/client/cl_curl.h \
  #                    --replace libcurl.so.3 ${curl}/lib/libcurl.so
  #  cd ..
  #'';
  buildInputs = [ unzip SDL mesa ];
  buildPhase = ''
    for d in ioUrbanTerrorClientSource ioUrbanTerrorServerSource
    do
      cd $d
      make
      cd ..
    done
  '';
  installPhase = ''
    destDir="$out/opt/urbanterror"
    ensureDir "$destDir"
    ensureDir "$out/bin"
    cp -v ioUrbanTerrorClientSource/build/release-linux-*/ioUrbanTerror.* \
          "$destDir/ioUrbanTerror"
    cp -v ioUrbanTerrorServerSource/build/release-linux-*/ioUrTded.* \
          "$destDir/ioUrTded"
    cp -rv UrbanTerror/q3ut4 "$destDir"
    cat << EOF > "$out/bin/urbanterror"
#!/bin/sh
cd "$destDir"
exec ./ioUrbanTerror "\$@"
EOF
    chmod +x "$out/bin/urbanterror"
    cat << EOF > "$out/bin/urbanterror-ded"
#!/bin/sh
cd "$destDir"
exec ./ioUrTded "\$@"
EOF
    chmod +x "$out/bin/urbanterror-ded"
  '';
  meta = {
    description = "A multiplayer tactical FPS on top of Quake 3 engine";
    longDescription = ''
      Urban Terror is a free multiplayer first person shooter developed by
      FrozenSand, that (thanks to the ioquake3-code) does not require
      Quake III Arena anymore. Urban Terror can be described as a Hollywood
      tactical shooter; somewhat realism based, but the motto is "fun over
      realism". This results in a very unique, enjoyable and addictive game.
    '';
    homepage = http://www.urbanterror.net;
    license = [ "unfree-redistributable" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
