{ lib, mkYarnPackage, fetchFromGitHub, nodejs, runtimeShell }:

# Notes for the upgrade:
# * Download the tarball of the new version to use.
# * Remove the `resolutions`-section from upstream `package.json`
#   as this breaks with `yarn2nix`.
# * Regenerate `yarn.lock` and `yarn2nix`.
# * Replace new `package.json`, `yarn.nix`, `yarn.lock` here.
# * Update `version`+`hash` and rebuild.

mkYarnPackage rec {
  name = "grafana-image-renderer";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    rev = "v${version}";
    sha256 = "sha256-3zvtlBjg+Yv5XDWdIN9HHLf+/Gv06ctbBaFhCgHeAMU=";
  };

  buildPhase = ''
    runHook preBuild

    pushd deps/renderer
    npm run build
    popd

    runHook postBuild
  '';

  dontInstall = true;

  packageJSON = ./package.json;
  yarnNix = ./yarn.nix;
  yarnLock = ./yarn.lock;

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
    platforms = platforms.linux;
  };
}
