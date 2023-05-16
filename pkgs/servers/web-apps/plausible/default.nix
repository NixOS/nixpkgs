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
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KcIZMsWlKGCZFi7DrTS8JMWEahdERoExtpBj+7Ec+FQ=";
=======
    sha256 = "1ckw5cd4z96jkjhmzjq7k3kzjj7bvj38i5xq9r43cz0sn7w3470k";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # TODO consider using `mix2nix` as soon as it supports git dependencies.
  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
<<<<<<< HEAD
    hash = "sha256-rLkD2FuNFKU3nB8FT/qPgSVP8H60qEmHtPvcdw4JUF8=";
=======
    sha256 = "1ikcskp4gvvdprl65x1spijdc8dz6klnrnkvgy2jbk0b3d7yn1v5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
  # https://github.com/whitfin/cachex/issues/205
  stripDebug = false;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    tests = { inherit (nixosTests) plausible; };
    updateScript = ./update.sh;
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace lib/plausible_release.ex --replace 'defp prepare do' 'def prepare do'
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    # broken since the deprecation of nodejs_16
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://plausible.io/";
    description = " Simple, open-source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics.";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
