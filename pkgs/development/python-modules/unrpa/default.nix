{
  lib,
  buildPythonPackage,
  fetchPypi,
  uncompyle6,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "unrpa";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yl4qdwp3in170ks98qnldqz3r2iyzil5g1775ccg98qkh95s724";
  };

  passthru.optional-dependencies = {
    ZiX = [ uncompyle6 ];
  };

  pythonImportsCheck = [ "unrpa" ];

  # upstream has no unit tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Lattyware/unrpa";
    changelog = "https://github.com/Lattyware/unrpa/releases/tag/${version}";
    description = "A program to extract files from the RPA archive format";
    mainProgram = "unrpa";
    license = licenses.gpl3;
    maintainers = with maintainers; [ leo60228 ];
  };
}
