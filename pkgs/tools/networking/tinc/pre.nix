{ stdenv, fetchgit, fetchpatch, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  name = "tinc-${version}";
  version = "1.1pre15";

  src = fetchgit {
    rev = "refs/tags/release-${version}";
    url = "git://tinc-vpn.org/tinc";
    sha256 = "1msym63jpipvzb5dn8yn8yycrii43ncfq6xddxh2ifrakr48l6y5";
  };

  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ ncurses readline zlib lzo openssl ];

  # needed so the build doesn't need to run git to find out the version.
  prePatch = ''
    substituteInPlace configure.ac --replace UNKNOWN ${version}
    echo "${version}" > configure-version
    echo "https://tinc-vpn.org/git/browse?p=tinc;a=log;h=refs/tags/release-${version}" > ChangeLog
    sed -i '/AC_INIT/s/m4_esyscmd_s.*/${version})/' configure.ac
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
    maintainers = with maintainers; [ wkennington fpletz lassulus ];
  };
}
