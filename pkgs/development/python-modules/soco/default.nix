{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, graphviz
, ifaddr
, isPy27
, lib
, mock
, nix-update-script
, pytestCheckHook
, requests
, requests-mock
, sphinx
, sphinx_rtd_theme
, toml
, xmltodict
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.21.2";
  disabled = isPy27;

  # N.B. We fetch from GitHub because the PyPI tarball doesn't contain the
  # required files to run the tests.
  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "v${version}";
    sha256 = "sha256-CCgkzUkt9YqTJt9tPBLmYXW6ZuRoMDd7xahYmNXgfM0=";
  };

  patches = [(fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/SoCo/SoCo/pull/811.patch";
    sha256 = "sha256-GBd74c8zc25ROO411SZ9TTa+bi8yXJaaOQqY9FM1qj4=";
  })];

  # N.B. These exist because:
  # 1. Upstream's pinning isn't well maintained, leaving dependency versions no
  #    longer in nixpkgs.
  # 2. There is no benefit for us to be running linting and coverage tests.
  postPatch = ''
    sed -i "/black/d" ./requirements-dev.txt
    sed -i "/coveralls/d" ./requirements-dev.txt
    sed -i "/flake8/d" ./requirements-dev.txt
    sed -i "/pylint/d" ./requirements-dev.txt
    sed -i "/pytest-cov/d" ./requirements-dev.txt
  '';

  propagatedBuildInputs = [
    ifaddr
    requests
    toml
    xmltodict
  ];

  checkInputs = [
    pytestCheckHook
    graphviz
    mock
    requests-mock
    sphinx
    sphinx_rtd_theme
  ];

  passthru.updateScript = nix-update-script {
    attrPath = "python3Packages.${pname}";
  };

  meta = with lib; {
    homepage = "http://python-soco.com/";
    description = "A CLI and library to control Sonos speakers";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
