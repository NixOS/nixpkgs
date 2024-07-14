{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cheroot,
  dbutils,
  mysqlclient,
  pymysql,
  mysql-connector,
  psycopg2,
}:

buildPythonPackage rec {
  version = "0.62";
  pname = "web.py";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XOaEyqJAZUyuWVDai0t7wXiBIDHgj5kFGNByvUSrUl4=";
  };

  propagatedBuildInputs = [ cheroot ];

  # requires multiple running databases
  doCheck = false;

  pythonImportsCheck = [ "web" ];

  nativeCheckInputs = [
    pytestCheckHook
    dbutils
    mysqlclient
    pymysql
    mysql-connector
    psycopg2
  ];

  meta = with lib; {
    description = "Makes web apps";
    longDescription = ''
      Think about the ideal way to write a web app.
      Write the code to make it happen.
    '';
    homepage = "https://webpy.org/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ layus ];
  };
}
