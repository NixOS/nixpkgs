{ stdenv, fetchFromGitHub, python3Packages, docutils, }:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jakubroztocil";
    repo = "httpie";
    rev = version;
    sha256 = "0d0rsn5i973l9y0ws3xmnzaw4jwxdlryyjbasnlddph5mvkf7dq0";
  };

  outputs = [ "out" "doc" "man" ];

  propagatedBuildInputs = with python3Packages; [ pygments requests setuptools ];
  dontUseSetuptoolsCheck = true;
  patches = [ ./strip-venv.patch ];

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
      ${docutils}/bin/rst2html5 \
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

    # change a few links to the local files
    substituteInPlace $docdir/html/index.html \
      --replace \
        'https://github.com/jakubroztocil/httpie/blob/master/CHANGELOG.rst' \
        "CHANGELOG.html" \
      --replace \
        'https://github.com/jakubroztocil/httpie/blob/master/CONTRIBUTING.rst' \
        "CONTRIBUTING.html"

    ${docutils}/bin/rst2man \
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

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = https://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod schneefux ];
  };
}
