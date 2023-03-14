{ lib
, asyncssh
, bcrypt
, buildPythonPackage
, fetchPypi
, fsspec
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sshfs";
  version = "2023.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-syIVtAi7aPeVPJSKHdDJIArsYj0mtIAP104vR3Vb1UQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asyncssh
    bcrypt
    fsspec
  ];

  meta = with lib; {
    description = "SSH/SFTP implementation for fsspec";
    homepage = "https://pypi.org/project/sshfs/${version}";
    changelog = "https://github.com/fsspec/sshfs/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
