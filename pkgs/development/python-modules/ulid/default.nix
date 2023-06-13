{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ulid";
  version = "1.1.0";

  src = fetchPypi {
    inherit version;
    pname = "ulid-py";
    sha256 = "sha256-3GiEvpFVjfB3wwEbn7DIfRCXy4/GU0sR8xAWGv1XOPA=";
  };

  meta = with lib; {
    description = "Universally Unique Lexicographically Sortable Identifier (ULID) in Python";
    homepage = "https://github.com/ahawker/ulid";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
