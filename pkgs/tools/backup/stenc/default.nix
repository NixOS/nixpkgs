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

  postPatch = ''
    # Fix gcc-13 build by pulling missing header. UPstream also fixed it
    # in next major version, but there are many other patch dependencies.
    # TODO: remove on next major version update
    sed -e '1i #include <cstdint>' -i src/scsiencrypt.h
  '';

  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "SCSI Tape Encryption Manager";
    mainProgram = "stenc";
    homepage = "https://github.com/scsitape/stenc";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}
