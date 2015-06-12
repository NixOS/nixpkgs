{ stdenv, fetchhg, cmake, SDL, mesa, fmod42416, openssl, sqlite, sqlite-amalgamation }:

stdenv.mkDerivation {
  name = "zandronum-2.0";
  src = fetchhg {
    url = "https://bitbucket.org/Torr_Samaho/zandronum";
    rev = "2fc02c0";
    sha256 = "1syzy0iphm6jj5wag3xyr2fx7vyg2cjcmijhvgw2rc67rww85pv2";
  };

  phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" ];

  buildInputs = [ cmake SDL mesa fmod42416 openssl sqlite sqlite-amalgamation ];

  preConfigure = ''
    cp ${sqlite-amalgamation}/* sqlite/
  '';

  cmakeFlags = [
    "-DFMOD_LIBRARY=${fmod42416}/lib/libfmodex.so"
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp zandronum zandronum.pk3 skulltag_actors.pk3 liboutput_sdl.so $out/share

    cat > $out/bin/zandronum << EOF
    #!/bin/sh

    LD_LIBRARY_PATH=$out/share $out/share/zandronum "\$@"
    EOF

    chmod +x "$out/bin/zandronum"
  '';

  meta = {
    homepage = http://zandronum.com/;
    description = "Multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software.";
    maintainer = [ stdenv.lib.maintainers.lassulus ];
  };
}

