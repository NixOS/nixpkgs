{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "pubs-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "v${version}";
    sha256 = "0n5wbjx9wqy6smfg625mhma739jyg7c92766biaiffp0a2bzr475";
  };

  propagatedBuildInputs = with python3Packages; [
    dateutil configobj bibtexparser pyyaml requests beautifulsoup4
    pyfakefs ddt
  ];

  preCheck = ''
    # API tests require networking
    rm tests/test_apis.py

    # pyfakefs works weirdly in the sandbox
    export HOME=/
  '';

  meta = with stdenv.lib; {
    description = "Command-line bibliography manager";
    homepage = https://github.com/pubs/pubs;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
