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
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
    sha256 = "1ckw5cd4z96jkjhmzjq7k3kzjj7bvj38i5xq9r43cz0sn7w3470k";
  };

  # TODO consider using `mix2nix` as soon as it supports git dependencies.
  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
    sha256 = "1ikcskp4gvvdprl65x1spijdc8dz6klnrnkvgy2jbk0b3d7yn1v5";
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

  postBuild = ''
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
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
