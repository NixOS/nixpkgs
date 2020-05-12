{ lib, buildPythonPackage, fetchPypi, uncompyle6, isPy27 }:

buildPythonPackage rec {
  pname = "unrpa";
  version = "2.3.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yl4qdwp3in170ks98qnldqz3r2iyzil5g1775ccg98qkh95s724";
  };

  propagatedBuildInputs = [ uncompyle6 ];

  pythonImportsCheck = [ "unrpa" ];

  meta = with lib; {
    homepage = "https://github.com/Lattyware/unrpa";
    description = "A program to extract files from the RPA archive format";
    license = licenses.gpl3;
    maintainers = with maintainers; [ leo60228 ];
  };
}
