{ lib, fetchFromGitHub, fetchpatch
, python3, xdg_utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "papis";
  version = "0.8.1";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    sha256 = "05l33fhp7iq5mv63mgn9mh2c4grr84szfgm5x0m2bh2mj8g1p8a7";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests filetype pyparsing configparser arxiv2bib
    pyyaml chardet beautifulsoup4 colorama bibtexparser
    pylibgen click python-slugify habanero isbnlib
    prompt_toolkit pygments
    # optional dependencies
    jinja2 whoosh
  ];

  postInstall = ''
    install -Dt "$out/etc/bash_completion.d" scripts/shell_completion/build/bash/papis
  '';

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
