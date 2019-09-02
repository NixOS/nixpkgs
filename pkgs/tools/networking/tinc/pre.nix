{ stdenv, fetchgit, fetchpatch, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl }:

stdenv.mkDerivation rec {
  pname = "tinc";
  version = "1.1pre17";

  src = fetchgit {
    rev = "refs/tags/release-${version}";
    url = "git://tinc-vpn.org/tinc";
    sha256 = "12abmx9qglchgn94a1qwgzldf2kaz77p8705ylpggzyncxv6bw2q";
  };

  outputs = [ "out" "man" "info" ];

  patches = [
    (fetchpatch {
      name = "tinc-openssl-1.0.2r.patch";
      url = "http://git.tinc-vpn.org/git/browse?p=tinc;a=patch;h=2b0aeec02d64bb4724da9ff1dbc19b7d35d7c904";
      sha256 = "0kidzlmgl0cin4g54ygcxa0jbq9vwlk3dyq5f65nkjd8yvayfzi8";
    })
  ];

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ ncurses readline zlib lzo openssl ];

  # needed so the build doesn't need to run git to find out the version.
  prePatch = ''
    substituteInPlace configure.ac --replace UNKNOWN ${version}
    echo "${version}" > configure-version
    echo "https://tinc-vpn.org/git/browse?p=tinc;a=log;h=refs/tags/release-${version}" > ChangeLog
    sed -i '/AC_INIT/s/m4_esyscmd_s.*/${version})/' configure.ac
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
    maintainers = with maintainers; [ fpletz lassulus ];
  };
}
