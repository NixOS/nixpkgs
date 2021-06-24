{ lib, fetchFromGitHub, python3Packages, docutils }:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "httpie";
    rev = version;
    sha256 = "00lafjqg9nfnak0nhcr2l2hzzkwn2y6qv0wdkm6r6f69snizy3hf";
  };

  patches = [
    ./strip-venv.patch
  ];

  outputs = [ "out" "doc" "man" ];

  nativeBuildInputs = [ docutils ];

  propagatedBuildInputs = with python3Packages; [ pygments requests requests-toolbelt setuptools ];

  checkInputs = with python3Packages; [
    mock
    pytest
    pytest-httpbin
    pytestCheckHook
  ];

  postInstall = ''
    # install completions
    install -Dm555 \
      extras/httpie-completion.bash \
      $out/share/bash-completion/completions/http.bash
    install -Dm555 \
      extras/httpie-completion.fish \
      $out/share/fish/vendor_completions.d/http.fish

    mkdir -p $man/share/man/man1

    docdir=$doc/share/doc/httpie
    mkdir -p $docdir/html

    cp AUTHORS.rst CHANGELOG.rst CONTRIBUTING.rst $docdir

    # helpfully, the readme has a `no-web` class to exclude
    # the parts that are not relevant for offline docs

    # this one build link was not marked however
    sed -e 's/^|build|//g' -i README.rst

    toHtml() {
      rst2html5 \
        --strip-elements-with-class=no-web \
        --title=http \
        --no-generator \
        --no-datestamp \
        --no-source-link \
        "$1" \
        "$2"
    }

    toHtml README.rst $docdir/html/index.html
    toHtml CHANGELOG.rst $docdir/html/CHANGELOG.html
    toHtml CONTRIBUTING.rst $docdir/html/CONTRIBUTING.html

    rst2man \
      --strip-elements-with-class=no-web \
      --title=http \
      --no-generator \
      --no-datestamp \
      --no-source-link \
      README.rst \
      $man/share/man/man1/http.1
  '';

  # the tests call rst2pseudoxml.py from docutils
  preCheck = ''
    export PATH=${docutils}/bin:$PATH
  '';

  checkPhase = ''
    py.test ./httpie ./tests --doctest-modules --verbose ./httpie ./tests -k 'not test_chunked and not test_verbose_chunked and not test_multipart_chunked and not test_request_body_from_file_by_path_chunked'
  '';

  meta = with lib; {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = "https://httpie.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ antono relrod schneefux SuperSandro2000 ];
  };
}
