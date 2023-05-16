{ lib
, fetchFromGitHub
<<<<<<< HEAD
, python3
, ffmpeg
}:
python3.pkgs.buildPythonApplication rec {
  pname = "gphotos-sync";
  version = "3.1.2";
  format = "pyproject";

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
, fetchpatch
, python3
, ffmpeg
}:
let
  py = python3.override {
    packageOverrides = self: super: {
      google-auth-oauthlib = super.google-auth-oauthlib.overridePythonAttrs (oldAttrs: rec {
        version = "0.5.2b1";
        src = fetchFromGitHub {
          owner = "gilesknap";
          repo = "google-auth-library-python-oauthlib";
          rev = "v${version}";
          hash = "sha256-o4Jakm/JgLszumrSoTTnU+nc79Ei70abjpmn614qGyc=";
        };
      });
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "gphotos-sync";
  version = "3.04";
  format = "pyproject";

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gilesknap";
    repo = "gphotos-sync";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-lLw450Rk7tIENFTZWHoinkhv3VtctDv18NKxhox+NgI=";
=======
    sha256 = "0mnlnqmlh3n1b6fjwpx2byl1z41vgghjb95598kz5gvdi95iirrs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./skip-network-tests.patch
  ];

<<<<<<< HEAD
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
    wheel
  ];

  pythonRelaxDeps = [
    "psutil"
    "exif"
    "pyyaml"
  ];

  propagatedBuildInputs = with python3.pkgs; [
=======
  propagatedBuildInputs = with py.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    appdirs
    attrs
    exif
    google-auth-oauthlib
    psutil
    pyyaml
<<<<<<< HEAD
    psutil
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    requests-oauthlib
    types-pyyaml
    types-requests
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    # this is a patched release that we include via packageOverrides above
    substituteInPlace setup.cfg \
      --replace " @ https://github.com/gilesknap/google-auth-library-python-oauthlib/archive/refs/tags/v0.5.2b1.zip" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    ffmpeg
  ];

<<<<<<< HEAD
  nativeCheckInputs = with python3.pkgs; [
=======
  nativeCheckInputs = with py.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mock
    pytestCheckHook
    setuptools-scm
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
