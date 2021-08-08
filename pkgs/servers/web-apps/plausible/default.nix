{ lib
, stdenv
, beamPackages
, fetchFromGitHub
, glibcLocales
, cacert
, mkYarnModules
, nodejs
, fetchpatch
, nixosTests
}:

let
  pname = "plausible";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
    sha256 = "03lm1f29gwwixnhgjish5bhi3m73qyp71ns2sczdnwnbhrw61zps";
  };

  # TODO consider using `mix2nix` as soon as it supports git dependencies.
  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
    sha256 = "1x0if0ifk272vcqjlgf097pxsw13bhwy8vs0b89l0bssx1bzygsi";

    # We need ecto 3.6 as this version checks whether the database exists before
    # trying to create it. The creation attempt would always require super-user privileges
    # and since 3.6 this isn't the case anymore.
    patches = [
      ./ecto_sql-fix.patch
      ./plausible-Bump-clickhouse_ecto-dependency-to-be-compatible-with-ecto-3.6.patch
    ];
  };

  yarnDeps = mkYarnModules {
    pname = "${pname}-yarn-deps";
    inherit version;
    packageJSON = ./package.json;
    yarnNix = ./yarn.nix;
    yarnLock = ./yarn.lock;
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

  patches = [
    # Allow socket-authentication against postgresql. Upstream PR is
    # https://github.com/plausible/analytics/pull/1052
    (fetchpatch {
      url = "https://github.com/Ma27/analytics/commit/f2ee5892a6c3e1a861d69ed30cac43e05e9cd36f.patch";
      sha256 = "sha256-JvJ7xlGw+tHtWje+jiQChVC4KTyqqdq2q+MIcOv/k1o=";
    })

    # Ensure that `tzdata` doesn't write into its store-path
    # https://github.com/plausible/analytics/pull/1096, but rebased onto 1.3.0
    ./tzdata-rebased.patch
  ];

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
