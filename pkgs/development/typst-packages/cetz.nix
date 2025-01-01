{
  lib,
  buildTypstPackage,
  fetchFromGitHub,
  just,
  file,
  perl,
  typstPackages,
}:

buildTypstPackage rec {
  pname = "cetz";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "cetz-package";
    repo = "cetz";
    tag = "v${version}";
    hash = "sha256-5+Np64+0Ca8yL7D1CCUewF03Wh6BM2bV1BQNUA+bW74=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    just
    perl
  ];

  typstDeps = [ typstPackages.oxifmt ];

  prePatch = ''
    patchShebangs --build scripts/package
  '';

  dontUseJustBuild = true;

  preInstall = ''
    export BUILD_DIR=$(mktemp -d)
    just install $BUILD_DIR
    rm -r *
    cp -r $BUILD_DIR/cetz/${version}/* .
  '';

  meta = {
    homepage = "https://github.com/cetz-package/cetz";
    description = "A library for drawing stuff with Typst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cherrypiejam ];
  };
}
