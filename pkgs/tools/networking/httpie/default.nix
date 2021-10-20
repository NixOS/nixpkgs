{ lib
, fetchFromGitHub
, installShellFiles
, python3Packages
, pandoc
}:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "httpie";
    rev = version;
    sha256 = "1y77dg27dn6bajwp3w6qvw1ls5wfhd1j1788l3fjhxg7j4qjki4g";
  };

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  propagatedBuildInputs = with python3Packages; [
    charset-normalizer
    defusedxml
    pygments
    requests
    requests-toolbelt
    setuptools
  ];

  checkInputs = with python3Packages; [
    mock
    pytest
    pytest-httpbin
    pytestCheckHook
    responses
  ];

  postInstall = ''
    # install completions
    installShellCompletion --bash \
      --name http.bash extras/httpie-completion.bash
    installShellCompletion --fish \
      --name http.fish extras/httpie-completion.fish

    # convert the docs/README.md file
    pandoc --standalone -f markdown -t man docs/README.md -o docs/http.1
    installManPage docs/http.1
  '';

  pytestFlagsArray = [
    "httpie"
    "tests"
  ];

  disabledTests = [
    "test_chunked"
    "test_verbose_chunked"
    "test_multipart_chunked"
    "test_request_body_from_file_by_path_chunked"
    # Part of doctest
    "httpie.encoding.detect_encoding"
  ];

  pythonImportsCheck = [ "httpie" ];

  meta = with lib; {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = "https://httpie.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ antono relrod schneefux SuperSandro2000 ];
  };
}
