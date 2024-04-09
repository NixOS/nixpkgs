{ lib
, pkgs
, python3Packages
, fetchPypi
, poetry-core
}:

python3Packages.buildPythonPackage rec {
  pname = "storage3";
  version = "0.7.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Yfy/g29WZAWYFyKrt9VsqlcCWyYeejFuczFnAavwwEA=";
  };

  propagatedBuildInputs = with python3Packages; [
    python-dateutil
    typing-extensions
    httpx
  ];

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];


  # tests are not in pypi package
  doCheck = false;


  meta = with lib; {
    homepage = "https://github.com/supabase-community/auth-py";
    license = licenses.mit;
    description = "Python Storage Client for Supabase";
    mainProgram = "storage3";
    maintainers = with maintainers; [ samrose ];
  };
}
