{ lib, fetchurl, appimageTools, pkgs }:

let
  pname = "bloomrpc";
  version = "1.5.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/uw-labs/${pname}/releases/download/${version}/BloomRPC-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    sha512 = "PebdYDpcplPN5y3mRu1mG6CXenYfYvBXNLgIGEr7ZgKnR5pIaOfJNORSNYSdagdGDb/B1sxuKfX4+4f2cqgb6Q==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 {
  inherit name src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

  extraInstallCommands = ''
    ln -s $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Inspired by Postman and GraphQL Playground
BloomRPC aims to provide the simplest and most efficient developer experience for exploring and querying your GRPC services.";
    homepage = "https://github.com/uw-labs/bloomrpc";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ matdsoupe ];
    platforms = [ "x86_64-linux" ];
  };
}
