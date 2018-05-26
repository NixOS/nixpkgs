{ lib, fetchpatch, python }:

let newPython = python.override {
  packageOverrides = self: super: {
    distro = super.distro.overridePythonAttrs (oldAttrs: rec {
      version = "1.1.0";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1vn1db2akw98ybnpns92qi11v94hydwp130s8753k6ikby95883j";
      };
    });
    node-semver = super.node-semver.overridePythonAttrs (oldAttrs: rec {
      version = "0.2.0";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1080pdxrvnkr8i7b7bk0dfx6cwrkkzzfaranl7207q6rdybzqay3";
      };
    });
  };
};

in newPython.pkgs.buildPythonApplication rec {
  version = "1.1.1"; # remove patch below when updating
  pname = "conan";

  src = newPython.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1k1r401bc9fgmhd5n5f29mjcn346r3zdrm7p28nwpr2r2p3fslrl";
  };

  checkInputs = with newPython.pkgs; [
    nose
    parameterized
    mock
    webtest
    codecov
  ];

  propagatedBuildInputs = with newPython.pkgs; [
    requests fasteners pyyaml pyjwt colorama patch
    bottle pluginbase six distro pylint node-semver
    future pygments mccabe
  ];

  patches = [
    # already merged, remove with the next package update
    (fetchpatch {
      url = "https://github.com/conan-io/conan/commit/51cc4cbd51ac8f9b9efa2bf678a2d7810e273ff3.patch";
      sha256 = "0d93g4hjpfk8z870imwdswkw5qba2h5zhfgwwijiqhr2pv7fl1y7";
    })
  ];

  preCheck = ''
    export HOME="$TMP/conan-home"
    mkdir -p "$HOME"
  '';

  meta = with lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
