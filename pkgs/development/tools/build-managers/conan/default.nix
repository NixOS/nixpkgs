{ lib, python3, git }:

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
      version = "0.6.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1dv6mjsm67l1razcgmq66riqmsb36wns17mnipqr610v0z0zf5j0";
      };
    });
    future = super.future.overridePythonAttrs (oldAttrs: rec {
      version = "0.16.0";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1nzy1k4m9966sikp0qka7lirh8sqrsyainyf8rk97db7nwdfv773";
      };
    });
    tqdm = super.tqdm.overridePythonAttrs (oldAttrs: rec {
      version = "4.28.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1fyybgbmlr8ms32j7h76hz5g9xc6nf0644mwhc40a0s5k14makav";
      };
    });
  };
};

in newPython.pkgs.buildPythonApplication rec {
  version = "1.12.0";
  pname = "conan";

  src = newPython.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0hgy3wfy96likdchz42h9mawfjw4dxx7k2iinrrlhph7128kji1j";
  };
  checkInputs = [
    git
  ] ++ (with newPython.pkgs; [
    codecov
    mock
    node-semver
    nose
    parameterized
    webtest
  ]);

  propagatedBuildInputs = with newPython.pkgs; [
    colorama deprecation distro fasteners bottle
    future node-semver patch pygments pluginbase
    pyjwt pylint pyyaml requests six tqdm
  ];

  checkPhase = ''
    export HOME="$TMP/conan-home"
    mkdir -p "$HOME"
  '';

  meta = with lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
    platforms = platforms.linux;
  };
}
