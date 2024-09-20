{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "polaris-web";
  version = "69";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris-web";
    rev = "build-${version}";
    hash = "sha256-/UmAOunc/79DpZByUrzqNA7q7JNugEceKRZvyTGhtVQ=";
  };

  npmDepsHash = "sha256-c11CWJB76gX+Bxmqac3VxWjJxQVzYCaaf+pmQQpnOds=";

  env.CYPRESS_INSTALL_BINARY = "0";

  npmBuildScript = "production";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/polaris-web

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web client for Polaris";
    homepage = "https://github.com/agersant/polaris-web";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
