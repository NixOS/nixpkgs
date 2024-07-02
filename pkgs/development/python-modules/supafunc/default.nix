{ lib
, pkgs
, python3Packages
, fetchPypi
, poetry-core
}:

python3Packages.buildPythonPackage rec {
  pname = "supafunc";
  version = "0.4.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pkZteL3KpYt/AwN5NkMQO6roEGqHrNXQHhlheanQ0CQ=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    httpx
  ];

  # tests are not in pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase-community/supabase-py";
    license = licenses.mit;
    description = "Python edge function client for Supabase";
    mainProgram = "supafunc";
    maintainers = with maintainers; [ samrose ];
  };
}
