{ lib, stdenv, python3, fetchFromGitHub, git, pkg-config }:

# Note:
# Conan has specific dependency demands; check
#     https://github.com/conan-io/conan/blob/master/conans/requirements.txt
#     https://github.com/conan-io/conan/blob/master/conans/requirements_server.txt
# on the release branch/commit we're packaging.
#
# Two approaches are used here to deal with that:
# Pinning the specific versions it wants in `newPython`,
# and using `substituteInPlace conans/requirements.txt ...`
# in `postPatch` to allow newer versions when we know
# (e.g. from changelogs) that they are compatible.

let newPython = python3.override {
  packageOverrides = self: super: {
    node-semver = super.node-semver.overridePythonAttrs (oldAttrs: rec {
      version = "0.6.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1dv6mjsm67l1razcgmq66riqmsb36wns17mnipqr610v0z0zf5j0";
      };
    });
    urllib3 = super.urllib3.overridePythonAttrs (oldAttrs: rec {
      version = "1.25.11";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "18hpzh1am1dqx81fypn57r2wk565fi4g14292qrc5jm1h9dalzld";
      };
    });
    # https://github.com/conan-io/conan/issues/8876
    pyjwt = super.pyjwt.overridePythonAttrs (oldAttrs: rec {
      version = "1.7.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96";
      };
      disabledTests = [
        "test_ec_verify_should_return_false_if_signature_invalid"
      ];
    });
    # conan needs jinja2<3
    jinja2 = super.jinja2.overridePythonAttrs (oldAttrs: rec {
      version = "2.11.3";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6";
      };
    });
    # old jinja2 needs old markupsafe
    markupsafe = super.markupsafe.overridePythonAttrs (oldAttrs: rec {
      version = "1.1.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b";
      };
    });
    # conan wants distro>=1.0.2, <=1.5.0
    distro = super.distro.overridePythonAttrs (oldAttrs: rec {
      version = "1.5.0";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "14nz51cqlnxmgfqqilxyvjwwa5xfivdvlm0d0b1qzgcgwdm7an0f";
      };
      doCheck = false;
    });
  };
};

in newPython.pkgs.buildPythonApplication rec {
  version = "1.39.0";
  pname = "conan";

  src = fetchFromGitHub {
    owner = "conan-io";
    repo = "conan";
    rev = version;
    sha256 = "sha256-MUciWz7EG/9PtEQ+t0nEDT8KMF6A/TlGrEVSIq3Fqqs=";
  };

  propagatedBuildInputs = with newPython.pkgs; [
    bottle
    colorama
    python-dateutil
    deprecation
    distro
    fasteners
    future
    jinja2
    node-semver
    patch-ng
    pluginbase
    pygments
    pyjwt
    pylint # Not in `requirements.txt` but used in hooks, see https://github.com/conan-io/conan/pull/6152
    pyyaml
    requests
    six
    tqdm
    urllib3
  ] ++ lib.optionals stdenv.isDarwin [ idna cryptography pyopenssl ];

  checkInputs = [
    pkg-config
    git
  ] ++ (with newPython.pkgs; [
    codecov
    mock
    nose
    parameterized
    webtest
  ]);

  # TODO: reenable tests now that we fetch tests w/ the source from GitHub.
  # Not enabled right now due to time constraints/failing tests that I didn't have time to track down
  doCheck = false;

  postPatch = ''
    substituteInPlace conans/requirements.txt \
      --replace "deprecation>=2.0, <2.1" "deprecation" \
      --replace "six>=1.10.0,<=1.15.0" "six>=1.10.0,<=1.16.0"
  '';

  meta = with lib; {
    homepage = "https://conan.io";
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };
}
