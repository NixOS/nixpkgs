{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "pubs";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "v${version}";
    sha256 = "0npgsyxj7kby5laznk5ilkrychs3i68y57gphwk48w8k9fvnl3zc";
  };

  propagatedBuildInputs = with python3Packages; [
    argcomplete python-dateutil configobj feedparser bibtexparser pyyaml requests six
    beautifulsoup4
  ];

  checkInputs = with python3Packages; [ pyfakefs mock ddt ];

  # Disabling git tests because they expect git to be preconfigured
  # with the user's details. See
  # https://github.com/NixOS/nixpkgs/issues/94663
  preCheck = ''
    rm tests/test_git.py
    '';

  meta = with lib; {
    description = "Command-line bibliography manager";
    homepage = "https://github.com/pubs/pubs";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ gebner ];
  };
}
