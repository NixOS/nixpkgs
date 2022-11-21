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
  version = "20.0.1";

  src = fetchzip {
    url = "https://github.com/keycloak/keycloak/releases/download/${version}/keycloak-${version}.zip";
    sha256 = "sha256-UriiCCVKxdcaKEcDyn8HsS1S4zJAUC2chYu6iiNsJwA=";
  };

  nativeBuildInputs = [ makeWrapper jre ];

  patches = [
    # Make home.dir and config.dir configurable through the
    # KC_HOME_DIR and KC_CONF_DIR environment variables.
    ./config_vars.patch
  ];

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
    patchShebangs bin/kc.sh
    export KC_HOME_DIR=$(pwd)
    export KC_CONF_DIR=$(pwd)/conf
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
