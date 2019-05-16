{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "sepaxml";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jhj8fa0lbyaw15q485kyyli9qgrmqr47a6z6pgqm40kwmjghiyc";
  };

  # no tests included in PyPI package
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/raphaelm/python-sepaxml/;
    description = "SEPA Direct Debit XML generation in python";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
