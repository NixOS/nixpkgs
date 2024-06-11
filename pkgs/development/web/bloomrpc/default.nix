{ lib, fetchurl, appimageTools }:

let
  pname = "bloomrpc";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/uw-labs/${pname}/releases/download/${version}/BloomRPC-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha512-PebdYDpcplPN5y3mRu1mG6CXenYfYvBXNLgIGEr7ZgKnR5pIaOfJNORSNYSdagdGDb/B1sxuKfX4+4f2cqgb6Q==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname src version;
  };
in
appimageTools.wrapType2 {
  inherit pname src version;

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "GUI Client for GRPC Services";
    longDescription = ''
      Inspired by Postman and GraphQL Playground BloomRPC aims to provide the simplest
      and most efficient developer experience for exploring and querying your GRPC services.
    '';
    homepage = "https://github.com/uw-labs/bloomrpc";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ zoedsoupe ];
    platforms = [ "x86_64-linux" ];
  };
}
