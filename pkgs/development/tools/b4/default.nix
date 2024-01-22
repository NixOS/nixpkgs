{ lib, python3Packages, fetchPypi, patatt }:

python3Packages.buildPythonApplication rec {
  pname = "b4";
  version = "0.12.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n3mLtthtTN1uAmsmM6dX+Nc7iEo5KzzHiH8iAJmV/Q0=";
  };

  # tests make dns requests and fails
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    requests
    dnspython
    dkimpy
    patatt
    git-filter-repo
  ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/about";
    license = licenses.gpl2Only;
    description = "A helper utility to work with patches made available via a public-inbox archive";
    mainProgram = "b4";
    maintainers = with maintainers; [ jb55 qyliss mfrw ];
  };
}
