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
  version = "3.2.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pyn/ehXVb5knHS1A/MFTYE0t+IVgtBe1dAnYdaHutyk=";
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
    mainProgram = "zfs-replicate";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil ];
  };
}
