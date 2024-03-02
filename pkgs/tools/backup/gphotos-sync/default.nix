{ lib
, fetchFromGitHub
, python3
, ffmpeg
}:
python3.pkgs.buildPythonApplication rec {
  pname = "gphotos-sync";
  version = "3.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gilesknap";
    repo = "gphotos-sync";
    rev = version;
    hash = "sha256-iTqD/oUQqC7Fju8SEPkSZX7FC9tE4eRCewiJR8STmEw=";
  };

  patches = [
    ./skip-network-tests.patch
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
    wheel
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
    export PY_IGNORE_IMPORTMISMATCH=1
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Google Photos and Albums backup with Google Photos Library API";
    homepage = "https://github.com/gilesknap/gphotos-sync";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
