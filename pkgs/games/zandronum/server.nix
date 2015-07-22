{ stdenv, fetchhg, cmake, openssl, sqlite, sqlite-amalgamation, SDL }:

stdenv.mkDerivation {
  name = "zandronum-server-2.1";
  src = fetchhg {
    url = "https://bitbucket.org/Torr_Samaho/zandronum-stable";
    rev = "27275a8";
    sha256 = "00xyrk0d1jrvy6zk059yawgd9b33z0fx4hvzcjvvbn03rqci60yc";
  };

  phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" ];

  buildInputs = [ cmake openssl sqlite sqlite-amalgamation SDL ];

  preConfigure = ''
    cp ${sqlite-amalgamation}/* sqlite/
  '';

  cmakeFlags = [
    "-DSERVERONLY=ON"
  ];

  installPhase = ''
    find
    mkdir -p $out/bin
    mkdir -p $out/share
    cp zandronum-server zandronum.pk3 skulltag_actors.pk3 $out/share

    cat > $out/bin/zandronum-server << EOF
    #!/bin/sh

    LD_LIBRARY_PATH=$out/share $out/share/zandronum-server "\$@"
    EOF

    chmod +x "$out/bin/zandronum-server"
  '';

  meta = {
    homepage = http://zandronum.com/;
    description = "Server of the multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software";
    maintainer = [ stdenv.lib.maintainers.lassulus ];
  };
}

