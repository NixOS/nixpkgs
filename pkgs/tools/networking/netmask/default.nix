{ stdenv, fetchFromGitHub, autoreconfHook, texinfo }:

stdenv.mkDerivation rec {
  name = "netmask-${version}";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "tlby";
    repo = "netmask";
    rev = "v${version}";
    sha256 = "1n6b9f60j7hfdbpbppgkhz3lr7pg963bxnfrq95i1d49xmx41f87";
  };

  buildInputs = [ texinfo ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tlby/netmask;
    description = "An IP address formatting tool ";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jensbin ];
  };
}
