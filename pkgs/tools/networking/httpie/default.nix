{ lib
, fetchFromGitHub
, installShellFiles
, python3
, pandoc
}:

python3.pkgs.buildPythonApplication rec {
  pname = "httpie";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "httpie";
    rev = version;
    hash = "sha256-x7Zucb2i8D4Xbn77eBzSxOAcc2fGg5MFKFiyJhytQ0s=";
  };

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  propagatedBuildInputs = with python3.pkgs; [
    charset-normalizer
    defusedxml
    multidict
    pygments
    requests
    requests-toolbelt
    setuptools
  ];

  checkInputs = with python3.pkgs; [
    mock
    pytest
    pytest-httpbin
    pytest-lazy-fixture
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

  pythonImportsCheck = [
    "httpie"
  ];

  meta = with lib; {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = "https://httpie.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ antono relrod schneefux SuperSandro2000 ];
  };
}
