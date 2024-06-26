{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cryptsetup,
}:

stdenv.mkDerivation rec {
  pname = "bruteforce-luks";
  version = "1.4.1";

  src = fetchFromGitHub {
    sha256 = "sha256-t07YyfCjaXQs/OMekcPNBT8DeSRtq2+8tUpsPP2pG7o=";
    rev = version;
    repo = "bruteforce-luks";
    owner = "glv2";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ cryptsetup ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Cracks passwords of LUKS encrypted volumes";
    mainProgram = "bruteforce-luks";
    longDescription = ''
      The program tries to decrypt at least one of the key slots by trying
      all the possible passwords. It is especially useful if you know
      something about the password (i.e. you forgot a part of your password but
      still remember most of it). Finding the password of a volume without
      knowing anything about it would take way too much time (unless the
      password is really short and/or weak). It can also use a dictionary.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
