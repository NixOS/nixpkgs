{
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyopenssl,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "servefile";
  version = "0.5.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sebageek";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hIqXwhmvstCslsCO973oK5FF2c8gZJ0wNUI/z8W+OjU=";
  };

  propagatedBuildInputs = [ pyopenssl ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];
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
    description = "Serve files from shell via a small HTTP server";
    mainProgram = "servefile";
    homepage = "https://github.com/sebageek/servefile";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samuela ];
  };
}
