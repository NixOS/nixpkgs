{ lib
, beamPackages
, fetchFromGitHub
, nodejs
, npmHooks
, fetchNpmDeps
, nixosTests
}:

let
  pname = "plausible";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
    hash = "sha256-yrTwxBguAZbfEKucUL+w49Hr6D7v9/2OjY1h27+w5WI=";
  };

  # TODO consider using `mix2nix` as soon as it supports git dependencies.
  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
    hash = "sha256-CAyZLpjmw1JreK3MopqI0XsWhP+fJEMpXlww7CibSaM=";
  };
in
beamPackages.mixRelease {
  inherit pname version src mixFodDeps;

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    src = "${src}/assets";
    hash = "sha256-2t1M6RQhBjZxx36qawVUVC+ob9SvQIq5dy4HgVeY2Eo=";
  };

  npmRoot = "assets";

  passthru = {
    tests = { inherit (nixosTests) plausible; };
    updateScript = ./update.sh;
  };

  postPatch = ''
    substituteInPlace lib/plausible_release.ex --replace 'defp prepare do' 'def prepare do'
  '';

  postBuild = ''
    export HOME=$TMPDIR
    export NODE_OPTIONS=--openssl-legacy-provider # required for webpack compatibility with OpenSSL 3 (https://github.com/webpack/webpack/issues/14532)
    npm run deploy --prefix ./assets

    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, phx.digest
  '';

  meta = with lib; {
    license = licenses.agpl3Plus;
    homepage = "https://plausible.io/";
    changelog = "https://github.com/plausible/analytics/blob/${src.rev}/CHANGELOG.md";
    description = " Simple, open-source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
