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
  version = "1.4.5";
  pname = "conan";

  src = newPython.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1mjakrv1d7la3lrxsv6jjqprqwmslpjmfxkw3z7pk56rzlp99nv2";
  };

  postPatch = ''
    # Remove pylint constraint
    substituteInPlace conans/requirements.txt --replace ", <1.9.0" ""
  '';

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
    future pygments mccabe deprecation
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
