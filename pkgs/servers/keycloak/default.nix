{ stdenv, lib, fetchzip, makeWrapper, jre, writeText, nixosTests
, postgresql_jdbc ? null, mysql_jdbc ? null
, callPackage
}:

let
  features = [];
  database = "dev-file";
in
stdenv.mkDerivation rec {
  pname   = "keycloak";
  version = "17.0.1";

  src = fetchzip {
    url    = "https://github.com/keycloak/keycloak/releases/download/${version}/keycloak-${version}.zip";
    sha256 = "sha256-z1LfTUoK+v4oQxdyIQruFhl5O333zirSrkPoTFgVfmI=";
  };

  nativeBuildInputs = [ makeWrapper jre ];

  buildPhase = ''
    bash -e bin/kc.sh build --db=${database} ${lib.concatMapStrings (x: " --features "+ x) features}
  '';

  installPhase = ''
    mkdir $out
    cp -r * $out
  '';
  preFixup = ''
    rm -rf $out/bin/*.bat
    for script in kcadm.sh kcreg.sh kc.sh; do
      wrapProgram $out/bin/$script --set JAVA_HOME ${jre}
    done
  '';

  passthru = {
    tests = nixosTests.keycloak;
    plugins = callPackage ./all-plugins.nix {};
  };

  meta = with lib; {
    homepage    = "https://www.keycloak.org/";
    description = "Identity and access management for modern applications and services";
    license     = licenses.asl20;
    platforms   = jre.meta.platforms;
    maintainers = with maintainers; [ ngerstle talyz ];
  };

}
