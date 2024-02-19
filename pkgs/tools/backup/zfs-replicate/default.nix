{ buildPythonApplication
, click
, fetchPypi
, hypothesis
, lib
, poetry-core
, pytest
, pytestCheckHook
, stringcase
}:

buildPythonApplication rec {
  pname = "zfs_replicate";
  version = "3.2.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q4m6/L7GZqCkvdKcWBGTfrbDC2UiFerluwNUOA+QCQU=";
  };

  postPatch = ''
    sed -i pyproject.toml -e '/--cov[^"]*/d'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pytest
  ];

  propagatedBuildInputs = [
    click
    stringcase
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/alunduil/zfs-replicate";
    description = "ZFS Snapshot Replication";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil ];
  };
}
