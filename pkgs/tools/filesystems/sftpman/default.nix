{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "sftpman";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "spantaleev";
    repo = pname;
    rev = version;
    hash = "sha256-YxqN4+u0nYUWehbyRhjddIo2sythH3E0fiPSyrUlWhM=";
  };

  checkPhase = ''
    $out/bin/sftpman help
  '';

  meta = with lib; {
    homepage = "https://github.com/spantaleev/sftpman";
    description = "Application that handles sshfs/sftp file systems mounting";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ contrun ];
  };
}
