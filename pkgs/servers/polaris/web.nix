{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "polaris-web";
  version = "67";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris-web";
    rev = "build-${version}";
    hash = "sha256-mhrgHNbqxLhhLWP4eu1A3ytrx9Q3X0EESL2LuTfgsBE=";
  };

  npmDepsHash = "sha256-lScXbxkJiRq5LLFkoz5oZsmKz8I/t1rZJVonfct9r+0=";

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
