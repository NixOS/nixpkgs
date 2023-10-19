{ lib, mkYarnPackage, fetchFromGitHub, fetchYarnDeps, nodejs, runtimeShell }:

# Notes for the upgrade:
# * Download the tarball of the new version to use.
# * Replace new `package.json` here.
# * Update `version`+`hash` and rebuild.

mkYarnPackage rec {
  pname = "grafana-image-renderer";
  version = "3.8.3";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    rev = "v${version}";
    hash = "sha256-3CaIVOzya0euQEpFAqqwy9L6Dn6qxPzpYFjJOL80Ka0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-GQ4dV3tyyKSYDA1tUgB+VaUBKIktdbx0o6GgBLQQkFc=";
  };

  packageJSON = ./package.json;

  buildPhase = ''
    runHook preBuild

    pushd deps/renderer
    yarn run build
    popd

    runHook postBuild
  '';

  dontInstall = true;

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
    platforms = platforms.all;
  };
}
