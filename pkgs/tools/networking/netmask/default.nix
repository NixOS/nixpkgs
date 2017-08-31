{stdenv, fetchFromGitHub, automake, autoconf, texinfo}:

stdenv.mkDerivation rec
{
  name = "netmask-${version}";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "tlby";
    repo = "netmask";
    rev = "v${version}";
    sha256 = "1n6b9f60j7hfdbpbppgkhz3lr7pg963bxnfrq95i1d49xmx41f87";
  };

  buildInputs = [ automake autoconf texinfo ];

  preConfigure = ''
  ./autogen
  '';

  meta =
  {
    homepage = https://github.com/tlby/netmask;
    description = "An IP address formatting tool ";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jensbin ];
  };
}
