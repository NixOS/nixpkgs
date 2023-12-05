{ lib
, fetchFromGitHub
, python3
, ffmpeg
}:
python3.pkgs.buildPythonApplication rec {
  pname = "gphotos-sync";
  version = "3.1.2";
  format = "pyproject";

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  src = fetchFromGitHub {
    owner = "gilesknap";
    repo = "gphotos-sync";
    rev = version;
    hash = "sha256-lLw450Rk7tIENFTZWHoinkhv3VtctDv18NKxhox+NgI=";
  };

  patches = [
    ./skip-network-tests.patch
  ];

  # Consider fixing this upstream by following up on:
  # https://github.com/gilesknap/gphotos-sync/issues/441
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools<57" "setuptools" \
      --replace "wheel==0.33.1" "wheel"
  '';

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
    setuptools
    setuptools-scm
    wheel
  ];

  pythonRelaxDeps = [
    "psutil"
    "exif"
    "pyyaml"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    attrs
    exif
    google-auth-oauthlib
    psutil
    pyyaml
    psutil
    requests-oauthlib
    types-pyyaml
    types-requests
  ];

  buildInputs = [
    ffmpeg
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    substituteInPlace setup.cfg \
      --replace "--cov=gphotos_sync --cov-report term --cov-report xml:cov.xml" ""
  '';

  meta = with lib; {
    description = "Google Photos and Albums backup with Google Photos Library API";
    homepage = "https://github.com/gilesknap/gphotos-sync";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
