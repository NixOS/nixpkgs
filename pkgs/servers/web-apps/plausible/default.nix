{ lib
, stdenv
, beamPackages
, fetchFromGitHub
, glibcLocales
, cacert
, mkYarnModules
, fetchYarnDeps
, nodejs
, nixosTests
}:

let
  pname = "plausible";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
    hash = "sha256-KcIZMsWlKGCZFi7DrTS8JMWEahdERoExtpBj+7Ec+FQ=";
  };

  # TODO consider using `mix2nix` as soon as it supports git dependencies.
  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
    hash = "sha256-rLkD2FuNFKU3nB8FT/qPgSVP8H60qEmHtPvcdw4JUF8=";
  };

  yarnDeps = mkYarnModules {
    pname = "${pname}-yarn-deps";
    inherit version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
    preBuild = ''
      mkdir -p tmp/deps
      cp -r ${mixFodDeps}/phoenix tmp/deps/phoenix
      cp -r ${mixFodDeps}/phoenix_html tmp/deps/phoenix_html
    '';
    postBuild = ''
      echo 'module.exports = {}' > $out/node_modules/flatpickr/dist/postcss.config.js
    '';
  };
in
beamPackages.mixRelease {
  inherit pname version src mixFodDeps;

  nativeBuildInputs = [ nodejs ];

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
    ln -sf ${yarnDeps}/node_modules assets/node_modules
    npm run deploy --prefix ./assets

    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, phx.digest
  '';

  meta = with lib; {
    license = licenses.agpl3Plus;
    homepage = "https://plausible.io/";
    description = " Simple, open-source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics.";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
