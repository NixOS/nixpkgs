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
  version = "3.2.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JMkZ4AexN++vPIPqzv9majdUkoAyos+Nm4Vlgeyx0Jg=";
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
