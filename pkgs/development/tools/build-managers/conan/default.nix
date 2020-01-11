{ lib, python3, git, pkgconfig }:

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
    pluginbase = super.pluginbase.overridePythonAttrs (oldAttrs: rec {
      version = "0.7";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "c0abe3218b86533cca287e7057a37481883c07acef7814b70583406938214cc8";
      };
    });
  };
};

in newPython.pkgs.buildPythonApplication rec {
  version = "1.12.3";
  pname = "conan";

  src = newPython.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1cnfy9b57apps4bfai6r67g0mrvgnqa154z9idv0kf93k1nvx53g";
  };

  propagatedBuildInputs = with newPython.pkgs; [
    colorama deprecation distro fasteners bottle
    future node-semver patch pygments pluginbase
    pyjwt pylint pyyaml requests six tqdm
  ];

  checkInputs = [
    pkgconfig
    git
  ] ++ (with newPython.pkgs; [
    codecov
    mock
    pytest
    node-semver
    nose
    parameterized
    webtest
  ]);

  checkPhase = ''
    export HOME=$TMPDIR
    pytest conans/test/{utils,unittests} \
      -k 'not SVN and not ToolsNetTest'
  '';

  postPatch = ''
    substituteInPlace conans/requirements_server.txt \
      --replace "pluginbase>=0.5, < 1.0" "pluginbase>=0.5"
    substituteInPlace conans/requirements.txt \
      --replace "PyYAML>=3.11, <3.14.0" "PyYAML"
  '';

  meta = with lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
    platforms = platforms.linux;
  };
}
