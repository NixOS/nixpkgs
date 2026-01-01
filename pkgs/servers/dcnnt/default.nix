{
  buildPythonApplication,
  fetchPypi,
  lib,
  pycryptodome,
}:

buildPythonApplication rec {
  pname = "dcnnt";
  version = "0.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-73ZLgb5YcXlAOjbKLVv8oqgS6pstBdJxa7LFUgIHpUE=";
  };

  propagatedBuildInputs = [
    pycryptodome
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/cyanomiko/dcnnt-py";
    description = "UI-less tool to connect Android phone with desktop";
    longDescription = ''
      Yet another tool to connect Android phone with desktop similar to
      KDE Connect.
    '';
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arnoutkroeze ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ arnoutkroeze ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "dcnnt";
  };
}
