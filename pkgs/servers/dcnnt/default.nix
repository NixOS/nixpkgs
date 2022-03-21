{ buildPythonApplication, fetchPypi, lib, pycryptodome }:

buildPythonApplication rec {
  pname = "dcnnt";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef8578526163cb3e25fa352ba2f6f4d39309f477a72282416c89eddfb69c3a91";
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
