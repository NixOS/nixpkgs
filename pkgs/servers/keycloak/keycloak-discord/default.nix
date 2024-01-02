{ stdenv
, lib
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "keycloak-discord";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/wadahiro/keycloak-discord/releases/download/v${version}/keycloak-discord-ear-${version}.ear";
    sha256 = "0fswhbnxc80dpfqf5y6j29dxk3vcnm4kki6qdk22qliasvpw5n9c";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"
    install "$src" "$out/${pname}-ear-${version}.ear"
  '';

  meta = with lib; {
    homepage = "https://github.com/wadahiro/keycloak-discord";
    description = "Keycloak Social Login extension for Discord";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
