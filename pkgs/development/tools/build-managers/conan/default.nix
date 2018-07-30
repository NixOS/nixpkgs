{ lib, python3, fetchpatch, git }:

let newPython = python3.override {
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
    astroid = super.astroid.overridePythonAttrs (oldAttrs: rec {
      version = "1.6.5";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "fc9b582dba0366e63540982c3944a9230cbc6f303641c51483fa547dcc22393a";
      };
    });
    pylint = super.pylint.overridePythonAttrs (oldAttrs: rec {
      version = "1.8.4";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "34738a82ab33cbd3bb6cd4cef823dbcabdd2b6b48a4e3a3054a2bbbf0c712be9";
      };

    });
  };
};

in newPython.pkgs.buildPythonApplication rec {
  version = "1.6.0";
  pname = "conan";

  src = newPython.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "386476d3af1fa390e4cd96e737876e7d1f1c0bca09519e51fd44c1bb45990caa";
  };

  # Bump PyYAML to 3.13
  patches = fetchpatch {
    url = https://github.com/conan-io/conan/commit/9d3d7a5c6e89b3aa321735557e5ad3397bb80568.patch;
    sha256 = "1qdy6zj3ypl1bp9872mzaqg1gwigqldxb1glvrkq3p4za62p546k";
  };

  checkInputs = [
    git
  ] ++ (with newPython.pkgs; [
    nose
    parameterized
    mock
    webtest
    codecov
  ]);

  propagatedBuildInputs = with newPython.pkgs; [
    requests fasteners pyyaml pyjwt colorama patch
    bottle pluginbase six distro pylint node-semver
    future pygments mccabe deprecation
  ];

  checkPhase = ''
    export HOME="$TMP/conan-home"
    mkdir -p "$HOME"
    nosetests conans.test
  '';

  meta = with lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
