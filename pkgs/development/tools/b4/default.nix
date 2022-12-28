{ lib, python3Packages, patatt }:

python3Packages.buildPythonApplication rec {
  pname = "b4";
  version = "0.10.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "zESWjmKz4DaiGg1VmbDlouTNm71YqIr1y9MCev72tEQ=";
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
    maintainers = with maintainers; [ jb55 qyliss ];
  };
}
