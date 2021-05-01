{ lib
, buildPythonPackage
, fetchPypi
, indexed-zstd
, indexed_gzip
, indexed_bzip2
, fusepy
, lzmaffi
}:

buildPythonPackage rec {
  pname = "ratarmount";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "032b77sl0c2g5k8a9ypp27v9c1q10471ql2gjl3ib8ax237qkyp5";
  };

  propagatedBuildInputs = [ indexed-zstd indexed_gzip indexed_bzip2 fusepy lzmaffi ];

  meta = with lib; {
    description = "Mounts archives as read-only file systems by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount";
    license = licenses.mit;
  };
}

