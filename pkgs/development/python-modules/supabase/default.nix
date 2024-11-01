{ lib
, pkgs
, python3Packages
, fetchPypi
, poetry-core
}:

python3Packages.buildPythonPackage rec {
  pname = "supabase";
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-p97AWG+JMfN4pFsv+yjY43s3Gfl5wX9UGwFWAZFE5kU=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    supabase_auth
    httpx
    postgrest
    realtime
    storage3
    supafunc
  ];

  # tests are not in pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase-community/supabase-py";
    license = licenses.mit;
    description = "Python Client for Supabase";
    mainProgram = "supabase";
    maintainers = with maintainers; [ samrose ];
  };
}
