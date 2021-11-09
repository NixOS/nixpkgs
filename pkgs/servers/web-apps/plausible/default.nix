{ lib
, stdenv
, beamPackages
, fetchFromGitHub
, glibcLocales
, cacert
, yarn2nix-moretea
, yarnSetupHook
, fetchYarnDeps
, nixosTests
}:

let
  pname = "plausible";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
    sha256 = "1d31y7mwvml17w97dm5c4312n0ciq39kf4hz3g80hdzbbn72mi4q";
  };

  # TODO consider using `mix2nix` as soon as it supports git dependencies.
  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
    sha256 = "1ikcskp4gvvdprl65x1spijdc8dz6klnrnkvgy2jbk0b3d7yn1v5";
  };

in
beamPackages.mixRelease {
  inherit pname version src mixFodDeps;

  nativeBuildInputs = [ yarnSetupHook ];

  passthru = {
    tests = { inherit (nixosTests) plausible; };
    updateScript = ./update.sh;
  };

  prePatch = ''
    cp ${./yarn.lock} assets/yarn.lock
    chmod u+w assets/yarn.lock
    mkdir deps
    cp -r ${mixFodDeps}/phoenix deps/phoenix
    cp -r ${mixFodDeps}/phoenix_html deps/phoenix_html
  '';

  offlineCache = yarn2nix-moretea.importOfflineCache ./yarn.nix;
  yarnFlags = yarnSetupHook.defaultYarnFlags;
  yarnRoot = "assets";

  postBuild = ''
    echo 'module.exports = {}' > assets/node_modules/flatpickr/dist/postcss.config.js
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
