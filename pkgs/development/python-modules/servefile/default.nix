{ stdenv
, buildPythonPackage
, fetchFromGitHub
, lib
, pyopenssl
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "servefile";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "sebageek";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/ZEMZIH/ImuZ2gh5bwB0FlaWnG/ELxfBGEJ2SuNSEb8=";
  };

  propagatedBuildInputs = [ pyopenssl ];

  checkInputs = [ pytestCheckHook requests ];
  # Test attempts to connect to a port on localhost which fails in nix build
  # environment.
  disabledTests = [
    "test_abort_download"
    "test_big_download"
    "test_https_big_download"
    "test_https"
    "test_redirect_and_download"
    "test_specify_port"
    "test_upload_size_limit"
    "test_upload"
  ];
  pythonImportsCheck = [ "servefile" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Serve files from shell via a small HTTP server";
    homepage = "https://github.com/sebageek/servefile";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samuela ];
  };
}
