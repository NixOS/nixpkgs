<<<<<<< HEAD
{ lib, mkYarnPackage, fetchFromGitHub, fetchYarnDeps, nodejs, runtimeShell }:

# Notes for the upgrade:
# * Download the tarball of the new version to use.
# * Replace new `package.json` here.
=======
{ lib, mkYarnPackage, fetchFromGitHub, nodejs, runtimeShell }:

# Notes for the upgrade:
# * Download the tarball of the new version to use.
# * Replace new `package.json`, `yarn.nix`, `yarn.lock` here.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# * Update `version`+`hash` and rebuild.

mkYarnPackage rec {
  pname = "grafana-image-renderer";
<<<<<<< HEAD
  version = "3.7.2";
=======
  version = "3.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-I5UHNt4vOsXqgeQ96CxJwxuD/MiGK1NEAFJItN1CkwA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-YT2tHvLtn4Z2CxH9utmsT8r/UM4/OdPFXByp9pBHDqU=";
  };

  packageJSON = ./package.json;

=======
    sha256 = "sha256-kbL6I2aFHyCmBiB1x02e3H7wIO4TE8ty6vHJEu/T8fI=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildPhase = ''
    runHook preBuild

    pushd deps/renderer
    yarn run build
    popd

    runHook postBuild
  '';

  dontInstall = true;

<<<<<<< HEAD
=======
  packageJSON = ./package.json;
  yarnNix = ./yarn.nix;
  yarnLock = ./yarn.lock;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  distPhase = ''
    runHook preDist

    shopt -s extglob

    pushd deps/renderer
    install_path="$out/libexec/grafana-image-renderer"
    mkdir -p $install_path
    cp -R ../../node_modules $install_path
    cp -R ./!(node_modules) $install_path
    popd

    mkdir -p $out/bin
    cat >$out/bin/grafana-image-renderer <<EOF
    #! ${runtimeShell}
    ${nodejs}/bin/node $install_path/build/app.js \$@
    EOF
    chmod +x $out/bin/grafana-image-renderer

    runHook postDist
  '';

  meta = with lib; {
    homepage = "https://github.com/grafana/grafana-image-renderer";
    description = "A Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";
    license = licenses.asl20;
    maintainers = with maintainers; [ ma27 ];
<<<<<<< HEAD
    platforms = platforms.all;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
