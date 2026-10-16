{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cheroot,
  legacy-cgi,
  dbutils,
  mysqlclient,
  pymysql,
  mysql-connector-python,
  psycopg2,
}:

buildPythonPackage rec {
  version = "0.62";
  format = "setuptools";
  pname = "web.py";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XOaEyqJAZUyuWVDai0t7wXiBIDHgj5kFGNByvUSrUl4=";
  };

  propagatedBuildInputs = [
    cheroot
    legacy-cgi
  ];

  # requires multiple running databases
  doCheck = false;

  pythonImportsCheck = [ "web" ];

  nativeCheckInputs = [
    pytestCheckHook
    dbutils
    mysqlclient
    pymysql
    mysql-connector-python
    psycopg2
  ];

  meta = {
    description = "Makes web apps";
    longDescription = ''
      Think about the ideal way to write a web app.
      Write the code to make it happen.
    '';
    homepage = "https://webpy.org/";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ layus ];
  };
}
