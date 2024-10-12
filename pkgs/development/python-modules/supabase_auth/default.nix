{ lib
, pkgs
, python3Packages
, fetchPypi
, poetry-core
}:

python3Packages.buildPythonPackage rec {
  pname = "gotrue";
  version = "2.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4QB0UWHxxY3QW5we+LzUzXjN+zjY0sJTreYxQ6Pcaus=";
  };

  propagatedBuildInputs = with python3Packages; [
    httpx
    pyjwt
    pydantic
  ];

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];


  # tests are not in pypi package
  doCheck = false;


  meta = with lib; {
    homepage = "https://github.com/supabase-community/auth-py";
    license = licenses.mit;
    description = "Python Auth Client for Supabase";
    mainProgram = "gotrue";
    maintainers = with maintainers; [ samrose ];
  };
}
