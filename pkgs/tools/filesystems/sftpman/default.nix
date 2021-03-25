{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "sftpman";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "spantaleev";
    repo = pname;
    rev = version;
    sha256 = "04awwwfw51fi1q18xdysp54jyhr0rhb4kfyrgv0vhhrlpwwyhnqy";
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
