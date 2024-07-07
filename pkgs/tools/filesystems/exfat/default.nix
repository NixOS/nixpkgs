{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, fuse }:

stdenv.mkDerivation rec {
  pname = "exfat";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "relan";
    repo = "exfat";
    rev = "v${version}";
    sha256 = "sha256-5m8fiItEOO6piR132Gxq6SHOPN1rAFTuTVE+UI0V00k=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse ];

  meta = with lib; {
    description = "Free exFAT file system implementation";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.unix;
  };
}
