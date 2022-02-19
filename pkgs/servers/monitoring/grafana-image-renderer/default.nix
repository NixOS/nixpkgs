{ lib, mkYarnPackage, fetchFromGitHub, nodejs, runtimeShell
, nodePackages, python3, vips, glib, pkg-config
}:

# Notes for the upgrade:
# * Download the tarball of the new version to use.
# * Remove the `resolutions`-section from upstream `package.json`
#   as this breaks with `yarn2nix`.
# * Regenerate `yarn.lock` and `yarn2nix --no-patch`.
# * Replace new `package.json`, `yarn.nix`, `yarn.lock` here.
# * Update `version`+`hash` and rebuild.

mkYarnPackage rec {
  pname = "grafana-image-renderer";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    rev = "v${version}";
    sha256 = "sha256-6yw+zp83T6VVa4A9KYX6rzMKG5GoyJ7M8Z+cEHE4uts=";
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

  pkgConfig.sharp = {
    nativeBuildInputs = [ nodePackages.node-gyp python3 pkg-config ];
    buildInputs = [ glib vips ];
    postInstall = ''
      node-gyp rebuild
    '';
  };

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
