{ buildPythonApplication, fetchPypi, lib, pycryptodome }:

buildPythonApplication rec {
  pname = "dcnnt";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YG+NLKI9cz8Uu2y+Ut2q+vn67ExTya00XjHlWRAksz8=";
  };

  propagatedBuildInputs = [
    pycryptodome
  ];

  meta = with lib; {
    homepage = "https://github.com/cyanomiko/dcnnt-py";
    description = "UI-less tool to connect Android phone with desktop";
    longDescription = ''
      Yet another tool to connect Android phone with desktop similar to
      KDE Connect.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ arnoutkroeze ];
  };
}
