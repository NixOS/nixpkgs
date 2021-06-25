{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "tnat64";
  version = "0.05";

  src = fetchFromGitHub {
    owner = "andrewshadura";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "07lmzidbrd3aahk2jvv93cic9gf36pwmgfd63gmy6hjkxf9a6fw9";
  };

  postPatch = ''
    # Fix usage of deprecated sys_errlist
    substituteInPlace tnat64.c --replace 'sys_errlist[errno]' 'strerror(errno)'
  '';

  configureFlags = [ "--libdir=$(out)/lib" ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "IPv4 to IPv6 interceptor";
    homepage = "https://github.com/andrewshadura/tnat64";
    license = licenses.gpl2Plus;
    longDescription = ''
      TNAT64 is an interceptor which redirects outgoing TCPv4 connections
      through NAT64, thus enabling an application running on an IPv6-only host
      to communicate with the IPv4 world, even if that application does not
      support IPv6 at all.
    '';
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    maintainers = [ maintainers.rnhmjoj ];
  };

}
