{ lib, fetchFromGitHub, fetchpatch
, python3, xdg_utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "papis";
  version = "0.8.2";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sa4hpgjvqkjcmp9bjr27b5m5jg4pfspdc8nf1ny80sr0kzn72hb";
  };

  patches = [
    # Update click version to 7.0.0
    (fetchpatch {
      url = https://github.com/papis/papis/commit/fddb80978a37a229300b604c26e992e2dc90913f.patch;
      sha256 = "0cmagfdaaml1pxhnxggifpb47z5g1p231qywnvnqpd3dm93382w1";
    })
    # Allow python-slugify >= 2.0.0
    (fetchpatch {
      url = https://github.com/papis/papis/commit/b023ca0e551a29c0c15f73fa071addd3e61fa36d.patch;
      sha256 = "0ybfzr5v1zg9m201jq4hyc6imqd8l4mx9azgjjxkgxcwd3ib1ymq";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests filetype pyparsing configparser arxiv2bib
    pyyaml chardet beautifulsoup4 colorama bibtexparser
    pylibgen click python-slugify habanero isbnlib
    prompt_toolkit pygments
    # optional dependencies
    jinja2 whoosh
  ];

  checkInputs = (with python3.pkgs; [
    pytest
  ]) ++ [
    xdg_utils
  ];

  # most of the downloader tests and 4 other tests require a network connection
  checkPhase = ''
    HOME=$(mktemp -d) pytest papis tests --ignore tests/downloaders \
      -k "not test_get_data and not test_doi_to_data and not test_general and not get_document_url"
  '';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = http://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
