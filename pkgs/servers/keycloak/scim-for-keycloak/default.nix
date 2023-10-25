{ lib
, fetchFromGitHub
, maven
}:

maven.buildMavenPackage rec {
  pname = "scim-for-keycloak";
  version = "kc-15-b2"; # When updating also update mvnHash

  src = fetchFromGitHub {
    owner = "Captain-P-Goldfish";
    repo = "scim-for-keycloak";
    rev = version;
    sha256 = "K34c7xISjEETI3jFkRLdZ0C8pZHTWtPtrrIzwC76Tv0=";
  };

  mvnHash = "sha256-MWxm2q6tx8YcdEsleC2h+s+lp9whi11VQ1yFr8AZUyQ=";

  nativeBuildInputs = [
    maven
  ];

  installPhase = ''
    EAR=$(find -iname "*.ear")
    install -D "$EAR" "$out/$(basename $EAR)"
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
