{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gpart";
  version = "0.3";

  # GitHub repository 'collating patches for gpart from all distributions':
  src = fetchFromGitHub {
    sha256 = "1lsd9k876p944k9s6sxqk5yh9yr7m42nbw9vlsllin7pd4djl4ya";
    rev = version;
    repo = "gpart";
    owner = "baruch";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Guess PC-type hard disk partitions";
    longDescription = ''
      Gpart is a tool which tries to guess the primary partition table of a
      PC-type hard disk in case the primary partition table in sector 0 is
      damaged, incorrect or deleted. The guessed table can be written to a file
      or device.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "gpart";
  };
}
