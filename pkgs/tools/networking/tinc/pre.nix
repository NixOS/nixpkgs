{ stdenv, fetchgit, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-${version}";
  rev = "d8ca00fe40ff4b6d87e7e64c273f536fab462356";
  version = "1.1pre-2016-01-28-${builtins.substring 0 7 rev}";

  src = fetchgit {
    inherit rev;
    url = "git://tinc-vpn.org/tinc";
    sha256 = "0wqgzbqlafbkmj71vhfrqwmp61g95amzd43py47kq3fn5aiybcqf";
  };

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ ncurses readline zlib lzo openssl ];

  prePatch = ''
    substituteInPlace configure.ac --replace UNKNOWN ${version}
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = with stdenv.lib; {
    description = "VPN daemon with full mesh routing";
    longDescription = ''
      tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
      encryption to create a secure private network between hosts on the
      Internet.  It features full mesh routing, as well as encryption,
      authentication, compression and ethernet bridging.
    '';
    homepage="http://www.tinc-vpn.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
