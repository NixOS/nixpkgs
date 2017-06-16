{ stdenv, fetchFromGitHub, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-${version}";
  version = "1.1pre14+20170528";

  src = fetchFromGitHub {
    owner = "gsliepen";
    repo = "tinc";
    rev = "93584bc1cad7c7cc9c95859a8cde548bc18b6fa8";
    sha256 = "17dpv3nv50jnzlijan4rfkz3mfgbwq65a42al0w846p70y6dgn8s";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ ncurses readline zlib lzo openssl ];

  prePatch = ''
    substituteInPlace configure.ac --replace UNKNOWN ${version}
  '';

  postInstall = ''
    rm $out/bin/tinc-gui
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
