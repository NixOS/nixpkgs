{ fetchFromGitHub, lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "jinja2-cli";
  version = "0.8.2";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-oWuxRUEREo4gb1aMlZOM3vW1oTmSk3j3K7jPYXnhjlA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    jinja2
    pyyaml
    toml
    xmltodict
  ];

  doCheck = false; # no tests on PyPi

  meta = with lib; {
    description = "CLI for Jinja2";
    homepage = "https://github.com/mattrobenolt/jinja2-cli";
    license = licenses.bsd2;
    maintainers = with maintainers; [ veprbl ];
  };
}
