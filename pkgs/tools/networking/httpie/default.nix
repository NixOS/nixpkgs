{ stdenv, fetchFromGitHub, python3Packages, docutils, fetchpatch }:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "jakubroztocil";
    repo = "httpie";
    rev = version;
    sha256 = "0caazv24jr0844c4mdx77vzwwi5m869n10wa42cydb08ppx1xxj6";
  };

  outputs = [ "out" "doc" "man" ];

  propagatedBuildInputs = with python3Packages; [ pygments requests setuptools ];
  dontUseSetuptoolsCheck = true;
  patches = [
    ./strip-venv.patch

    # Fix `test_ciphers_none_can_be_selected`
    # TODO: remove on next release
    (fetchpatch {
      url = "https://github.com/jakubroztocil/httpie/commit/49e71d252f54871a6bc49cb1cba103d385a543b8.patch";
      sha256 = "13b2faf50gimj7f17dlx4gmd8ph8ipgihpzfqbvmfjlbf1v95fsj";
    })
  ];

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
    homepage = "https://httpie.org/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod schneefux ];
  };
}
