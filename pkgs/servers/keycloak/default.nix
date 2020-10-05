{ stdenv, fetchzip, makeWrapper, jre, writeText
, postgresql_jdbc ? null
}:

let
  mkModuleXml = name: jarFile: writeText "module.xml" ''
    <?xml version="1.0" ?>
    <module xmlns="urn:jboss:module:1.3" name="org.${name}">
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
  version = "11.0.2";

  src = fetchzip {
    url    = "https://downloads.jboss.org/keycloak/${version}/keycloak-${version}.zip";
    sha256 = "0ayg6cl6mff64qs36djnfs3is4x0pzhk7zwb27cbln77q3icc0j0";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    cp -r * $out

    rm -rf $out/bin/*.{ps1,bat}

    module_path=$out/modules/system/layers/keycloak/org
    if ! [[ -d $module_path ]]; then
        echo "The module path $module_path not found!"
        exit 1
    fi

    ${if postgresql_jdbc != null then ''
      mkdir -p $module_path/postgresql/main
      ln -s ${postgresql_jdbc}/share/java/postgresql-jdbc.jar $module_path/postgresql/main
      ln -s ${mkModuleXml "postgresql" "postgresql-jdbc.jar"} $module_path/postgresql/main/module.xml
    '' else ""}

    wrapProgram $out/bin/standalone.sh --set JAVA_HOME ${jre}
    wrapProgram $out/bin/add-user-keycloak.sh --set JAVA_HOME ${jre}
    wrapProgram $out/bin/jboss-cli.sh --set JAVA_HOME ${jre}
  '';

  meta = with stdenv.lib; {
    homepage    = "https://www.keycloak.org/";
    description = "Identity and access management for modern applications and services";
    license     = licenses.asl20;
    platforms   = jre.meta.platforms;
    maintainers = with maintainers; [ ngerstle talyz ];
  };

}
