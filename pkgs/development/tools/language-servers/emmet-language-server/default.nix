{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "emmet-language-server";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "olrtg";
    repo = "emmet-language-server";
    rev = "v${version}";
    hash = "sha256-53FbZ0hC2s9o6yXPYAy0vqe4tLcYMHLqeBMNuNI8Nd0=";
  };

  npmDepsHash = "sha256-luE8iYfTsSrBVcv0sE1yYnAksE2+icx9K4yNzjUV7U4=";

  # Upstream doesn't have a lockfile
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  meta = with lib; {
    description = "Language server for emmet.io";
    homepage = "https://github.com/olrtg/emmet-language-server";
    changelog = "https://github.com/olrtg/emmet-language-server/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ stnley ];
    mainProgram = "emmet-language-server";
  };
}
