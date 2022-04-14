with import <nixpkgs>{};

let
  version = "1.5.3";
  pname = "bloomrpc";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/bloomrpc/bloomrpc/releases/download/1.5.3/BloomRPC-${version}.AppImage";
    sha256 = "9fba03507d78342b9eb045bed256864bb5bfa1247d3374dd396d66b996fa5f2b";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraPkgs = pkgs: with pkgs; [
    gsettings-desktop-schemas
  ];

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/bloomrpc.desktop $out/share/applications/bloomrpc.desktop
    install -m 444 -D ${appimageContents}/bloomrpc.png $out/share/icons/hicolor/512x512/apps/bloomrpc.png
    substituteInPlace $out/share/applications/bloomrpc.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "The missing GUI Client for GRPC services.";
    longDescription = ''
      Inspired by Postman and GraphQL Playground
      BloomRPC aims to provide the simplest and most efficient developer experience for exploring and querying your GRPC services.

      Install the client, select your protobuf files and start making requests!
      No extra steps or configuration needed.'';
    homepage = "https://github.com/bloomrpc/bloomrpc";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mwdomino ];
    platforms = [ "x86_64-linux" ];
  };
}
