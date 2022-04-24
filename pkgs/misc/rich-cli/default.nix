{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "rich-cli";
  version = "1.5.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "18qpdaw4drkwq71xikngwaarkjxhfc0nrb1zm36rw31b8dz0ij2k";
  };

  format = "pyproject";

  nativeBuildInputs = [ python3.pkgs.poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    rich
    click
    requests
    textual
    rich-rst
  ];

  buildInputs = [ python3 ];

  meta = with lib; {
    homepage = "https://github.com/Textualize/rich-cli";
    description = "Command Line Interface to Rich";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
