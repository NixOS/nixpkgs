{ lib, stdenv, python3, fetchFromGitHub, git, pkg-config, fetchpatch }:

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
    distro = super.distro.overridePythonAttrs (oldAttrs: rec {
      version = "1.1.0";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1vn1db2akw98ybnpns92qi11v94hydwp130s8753k6ikby95883j";
      };
      patches = oldAttrs.patches or [] ++ [
        # Don't raise import error on non-linux os. Remove after upgrading to distro≥1.2.0
        (fetchpatch {
          url = "https://github.com/nir0s/distro/commit/25aa3f8c5934346dc838387fc081ce81baddeb95.patch";
          sha256 = "0m09ldf75gacazh2kr04cifgsqfxg670vk4ypl62zv7fp3nyd5dc";
        })
      ];
    });
    node-semver = super.node-semver.overridePythonAttrs (oldAttrs: rec {
      version = "0.6.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1dv6mjsm67l1razcgmq66riqmsb36wns17mnipqr610v0z0zf5j0";
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
  version = "1.27.0";
  pname = "conan";

  src = fetchFromGitHub {
    owner = "conan-io";
    repo = "conan";
    rev = version;
    sha256 = "0ncqs1p4g23fmzgdmwppgxr8w275h38hgjdzs456cgivz8xs9rjl";
  };

  propagatedBuildInputs = with newPython.pkgs; [
    bottle
    colorama
    dateutil
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
      --replace "PyYAML>=3.11, <3.14.0" "PyYAML" \
      --replace "deprecation>=2.0, <2.1" "deprecation" \
      --replace "idna==2.6" "idna" \
      --replace "cryptography>=1.3.4, <2.4.0" "cryptography" \
      --replace "pyOpenSSL>=16.0.0, <19.0.0" "pyOpenSSL" \
      --replace "six>=1.10.0,<=1.14.0" "six"
  '';

  meta = with lib; {
    homepage = "https://conan.io";
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };
}
