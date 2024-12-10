{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  expat,
  libaio,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "thin-provisioning-tools";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "v${version}";
    sha256 = "1iwg04rhmdhijmlk5hfl8wvv83115lzb65if6cc1glkkfva8jfjp";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    expat
    libaio
    boost
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/jthornber/thin-provisioning-tools/";
    description = "A suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
