{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "stenc";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "scsitape";
    repo = "stenc";
    rev = version;
    sha256 = "GcCRVkv+1mREq3MhMRn5fICthwI4WRQJSP6InuzxP1Q=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = {
    description = "SCSI Tape Encryption Manager";
    homepage = "https://github.com/scsitape/stenc";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}
