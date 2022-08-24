{ stdenv
, lib
, fetchzip
, makeWrapper
, jre
, writeText
, nixosTests
, callPackage

, confFile ? null
, plugins ? [ ]
}:

stdenv.mkDerivation rec {
  pname = "keycloak";
  version = "19.0.1";

  src = fetchzip {
    url = "https://github.com/keycloak/keycloak/releases/download/${version}/keycloak-${version}.zip";
    sha256 = "sha256-3hqnFH0zWvgOgpQHV4eMqTGzUWEoRwxvOcOUL2s8YQk=";
  };

  nativeBuildInputs = [ makeWrapper jre ];

  buildPhase = ''
    runHook preBuild
  '' + lib.optionalString (confFile != null) ''
    install -m 0600 ${confFile} conf/keycloak.conf
  '' + ''
    install_plugin() {
    if [ -d "$1" ]; then
      find "$1" -type f \( -iname \*.ear -o -iname \*.jar \) -exec install -m 0500 "{}" "providers/" \;
    else
      install -m 0500 "$1" "providers/"
    fi
    }
    ${lib.concatMapStringsSep "\n" (pl: "install_plugin ${lib.escapeShellArg pl}") plugins}
  '' + ''
    export KC_HOME_DIR=$out
    export KC_CONF_DIR=$out/conf

    patchShebangs bin/kc.sh
    bin/kc.sh build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out

    rm $out/bin/*.{ps1,bat}

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/bin/kc.sh --replace ${lib.escapeShellArg "-Dkc.home.dir='$DIRNAME'/../"} '-Dkc.home.dir=$KC_HOME_DIR'
    substituteInPlace $out/bin/kc.sh --replace ${lib.escapeShellArg "-Djboss.server.config.dir='$DIRNAME'/../conf"} '-Djboss.server.config.dir=$KC_CONF_DIR'

    for script in $(find $out/bin -type f -executable); do
      wrapProgram "$script" --set JAVA_HOME ${jre} --prefix PATH : ${jre}/bin
    done
  '';

  passthru = {
    tests = nixosTests.keycloak;
    plugins = callPackage ./all-plugins.nix { };
    enabledPlugins = plugins;
  };

  meta = with lib; {
    homepage = "https://www.keycloak.org/";
    description = "Identity and access management for modern applications and services";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = jre.meta.platforms;
    maintainers = with maintainers; [ ngerstle talyz ];
  };

}
