{ stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  pname = "pfsshell";

  src = fetchFromGitHub {
    owner = "uyjulian";
    repo = "pfsshell";
    rev = "v${version}";
    sha256 = "10bkihb6qwh2difmrrxsaszq1rhgq0gw55l1hry0nilkr7l6i62v";
  };

  nativeBuildInputs = [ meson ninja ];
  hardeningDisable = [ "format" "fortify" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "PFS (PlayStation File System) shell for POSIX-based systems";
    platforms = platforms.unix;
    license = licenses.gpl2; #The APA, PFS, and iomanX libraries are licensed under the The Academic Free License version 2.
    maintainers = with maintainers; [ genesis ];
  };
}
