{ lib, stdenv, fetchFromGitHub, autoreconfHook, texinfo }:

stdenv.mkDerivation rec {
  pname = "netmask";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "tlby";
    repo = "netmask";
    rev = "v${version}";
    sha256 = "1269bmdvl534wr0bamd7cqbnr76pnb14yn8ly4qsfg29kh7hrds6";
  };

  buildInputs = [ texinfo ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/tlby/netmask";
    description = "IP address formatting tool ";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jensbin ];
    mainProgram = "netmask";
  };
}
