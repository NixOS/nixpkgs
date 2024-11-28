{ lib, stdenv, fetchFromGitHub, autoreconfHook, texinfo, ncurses, readline, zlib, lzo, openssl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "tinc";
  version = "1.1pre18";

  src = fetchFromGitHub {
    owner = "gsliepen";
    repo = "tinc";
    rev = "release-${version}";
    hash = "sha256-1anjTUlVLx57FlUqGwBd590lfkZ2MmrM1qRcMl4P7Sg=";
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

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  passthru.tests = { inherit (nixosTests) tinc; };

  meta = with lib; {
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
    maintainers = with maintainers; [ lassulus mic92 ];
  };
}
