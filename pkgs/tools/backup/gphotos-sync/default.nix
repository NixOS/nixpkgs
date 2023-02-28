{ lib
, fetchFromGitHub
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

  src = fetchFromGitHub {
    owner = "gilesknap";
    repo = "gphotos-sync";
    rev = version;
    sha256 = "0mnlnqmlh3n1b6fjwpx2byl1z41vgghjb95598kz5gvdi95iirrs";
  };

  patches = [
    ./skip-network-tests.patch
  ];

  propagatedBuildInputs = with py.pkgs; [
    appdirs
    attrs
    exif
    google-auth-oauthlib
    psutil
    pyyaml
    requests-oauthlib
    types-pyyaml
    types-requests
  ];

  postPatch = ''
    # this is a patched release that we include via packageOverrides above
    substituteInPlace setup.cfg \
      --replace " @ https://github.com/gilesknap/google-auth-library-python-oauthlib/archive/refs/tags/v0.5.2b1.zip" ""
  '';

  buildInputs = [
    ffmpeg
  ];

  nativeCheckInputs = with py.pkgs; [
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
