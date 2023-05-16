{ lib
<<<<<<< HEAD
, fetchFromGitHub
, maven
}:

maven.buildMavenPackage rec {
  pname = "scim-for-keycloak";
  version = "kc-20-b1"; # When updating also update mvnHash
=======
, stdenv
, fetchFromGitHub
, maven
, javaPackages
}:

javaPackages.mavenfod rec {
  pname = "scim-for-keycloak";
  version = "kc-15-b2"; # When updating also update mvnHash
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Captain-P-Goldfish";
    repo = "scim-for-keycloak";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-kHjCVkcD8C0tIaMExDlyQmcWMhypisR1nyG93laB8WU=";
  };

  mvnHash = "sha256-cOuJSU57OuP+U7lI+pDD7g9HPIfZAoDPYLf+eO+XuF4=";

  installPhase = ''
    install -D "scim-for-keycloak-server/target/scim-for-keycloak-${version}.jar" "$out/scim-for-keycloak-${version}.jar"
=======
    sha256 = "K34c7xISjEETI3jFkRLdZ0C8pZHTWtPtrrIzwC76Tv0=";
  };

  mvnHash = "sha256-kDYhXTEOAWH/dcRJalKtbwBpoxcD1aX9eqcRKs6ewbE=";

  nativeBuildInputs = [
    maven
  ];

  installPhase = ''
    EAR=$(find -iname "*.ear")
    install -D "$EAR" "$out/$(basename $EAR)"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    homepage = "https://github.com/Captain-P-Goldfish/scim-for-keycloak";
    description = "A third party module that extends Keycloak with SCIM functionality";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # dependencies
    ];
    license = licenses.bsd3;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
