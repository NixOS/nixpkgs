{ stdenv, lib, fetchzip, makeWrapper, jre, writeText, nixosTests
, postgresql_jdbc ? null, mysql_jdbc ? null
, callPackage
}:

let
  mkModuleXml = name: jarFile: writeText "module.xml" ''
    <?xml version="1.0" ?>
    <module xmlns="urn:jboss:module:1.3" name="${name}">
        <resources>
            <resource-root path="${jarFile}"/>
        </resources>
        <dependencies>
            <module name="javax.api"/>
            <module name="javax.transaction.api"/>
        </dependencies>
    </module>
  '';
in
stdenv.mkDerivation rec {
  pname   = "keycloak";
  version = "16.1.0";

  src = fetchzip {
    url    = "https://github.com/keycloak/keycloak/releases/download/${version}/keycloak-${version}.zip";
    sha256 = "sha256-QVFu3f+mwafoNUttLEVMdoZHMJjjH/TpZAGV7ZvIvh0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    cp -r * $out

    rm -rf $out/bin/*.{ps1,bat}

    module_path=$out/modules/system/layers/keycloak
    if ! [[ -d $module_path ]]; then
        echo "The module path $module_path not found!"
        exit 1
    fi

    ${lib.optionalString (postgresql_jdbc != null) ''
      mkdir -p $module_path/org/postgresql/main
      ln -s ${postgresql_jdbc}/share/java/postgresql-jdbc.jar $module_path/org/postgresql/main/
      ln -s ${mkModuleXml "org.postgresql" "postgresql-jdbc.jar"} $module_path/org/postgresql/main/module.xml
    ''}
    ${lib.optionalString (mysql_jdbc != null) ''
      mkdir -p $module_path/com/mysql/main
      ln -s ${mysql_jdbc}/share/java/mysql-connector-java.jar $module_path/com/mysql/main/
      ln -s ${mkModuleXml "com.mysql" "mysql-connector-java.jar"} $module_path/com/mysql/main/module.xml
    ''}

    for script in add-user-keycloak.sh add-user.sh domain.sh elytron-tool.sh jboss-cli.sh jconsole.sh jdr.sh standalone.sh wsconsume.sh wsprovide.sh; do
      wrapProgram $out/bin/$script --set JAVA_HOME ${jre}
    done
    wrapProgram $out/bin/kcadm.sh --prefix PATH : ${jre}/bin
    wrapProgram $out/bin/kcreg.sh --prefix PATH : ${jre}/bin
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
