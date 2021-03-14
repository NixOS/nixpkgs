{ lib
, stdenv
, fetchFromGitHub
, genericUpdater
, common-updater-scripts
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "stenc";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "scsitape";
    repo = "stenc";
    rev = version;
    sha256 = "0dsmvr1xpwkcd9yawv4c4vna67yag7jb8jcgn2amywz7nkpzmyxd";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = genericUpdater {
    inherit pname version;
    versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
  };

  meta = {
    description = "SCSI Tape Encryption Manager";
    homepage = "https://github.com/scsitape/stenc";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}
