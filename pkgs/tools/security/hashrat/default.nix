{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hashrat";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "ColumPaget";
    repo = "Hashrat";
    rev = "v${version}";
    hash = "sha256-+3IPCJS++7CE0ZrJb62LCRrAn2J4uCF3a1oOzDoOW0w=";
  };

  configureFlags = [ "--enable-xattr" ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Command-line hash-generation utility";
    mainProgram = "hashrat";
    longDescription = ''
      Hashing tool supporting md5,sha1,sha256,sha512,whirlpool,jh and hmac versions of these.
      Includes recursive file hashing and other features.
    '';
    homepage = "http://www.cjpaget.co.uk/Code/Hashrat";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
