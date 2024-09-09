{ lib
, fetchFromGitLab
, installShellFiles
, libsodium
, pkg-config
, protobuf
, rustPlatform
, fetchYarnDeps
, fixup-yarn-lock
, stdenv
, yarn
, nodejs
}:

rustPlatform.buildRustPackage rec {
  pname = "ratman";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "git.irde.st";
    owner = "we";
    repo = "irdest";
    rev = "${pname}-${version}";
    sha256 = "sha256-ZZ7idZ67xvQFmQJqIFU/l77YU+yDQOqNthX5NR/l4k8=";
  };

  cargoHash = "sha256-Nsux0QblBtzlhLEgfKYvkQrOz8+oVd2pqT3CL8TnQEc=";

  nativeBuildInputs = [ protobuf pkg-config installShellFiles ];

  cargoBuildFlags = [ "--all-features" "-p" "ratman" ];
  cargoTestFlags = cargoBuildFlags;

  buildInputs = [ libsodium ];

  postInstall = ''
    installManPage docs/man/ratmand.1
  '';

  SODIUM_USE_PKG_CONFIG = 1;

  dashboard = stdenv.mkDerivation rec {
    pname = "ratman-dashboard";
    inherit version src;
    sourceRoot = "${src.name}/ratman/dashboard";

    yarnDeps = fetchYarnDeps {
      yarnLock = src + "/ratman/dashboard/yarn.lock";
      sha256 = "sha256-pWjKL41r/bTvWv+5qCgCFVL9+o64BiV2/ISdLeKEOqE=";
    };

    nativeBuildInputs = [ yarn nodejs fixup-yarn-lock ];

    outputs = [ "out" "dist" ];

    buildPhase = ''
      # Yarn writes temporary files to $HOME. Copied from mkYarnModules.
      export HOME=$NIX_BUILD_TOP/yarn_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror ${yarnDeps}

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      fixup-yarn-lock yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive

      patchShebangs node_modules/

      # Build into `./dist/`, suppress formatting.
      yarn --offline build | cat
    '';

    installPhase = ''
      cp -R . $out

      mv $out/dist $dist
      ln -s $dist $out/dist
    '';
  };

  prePatch = ''
    cp -r ${dashboard.dist} ratman/dashboard/dist
  '';

  meta = with lib; {
    description = "Modular decentralised peer-to-peer packet router and associated tools";
    homepage = "https://git.irde.st/we/irdest";
    platforms = platforms.unix;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ spacekookie ];
  };
}
