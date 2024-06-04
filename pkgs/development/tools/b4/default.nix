{ lib, python3Packages, fetchPypi, patatt }:

python3Packages.buildPythonApplication rec {
  pname = "b4";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gsok5aDi5oYJPMXVv3MFAehyKZ5hHBtvwf7z6Ut4dBQ=";
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
