{ buildPythonApplication, fetchPypi, lib, pycryptodome }:

buildPythonApplication rec {
  pname = "dcnnt";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vKCQgg0m58hoN79WcZ4mM6bjCJOPxhAT4ifZ3b/5bkA=";
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
