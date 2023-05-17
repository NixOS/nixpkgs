{ lib, stdenv, fetchurl, gperf, guile, gmp, zlib, liboop, readline, gnum4, pam
, nettools, lsof, procps, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "lsh";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://gnu/lsh/lsh-${version}.tar.gz";
    sha256 = "614b9d63e13ad3e162c82b6405d1f67713fc622a8bc11337e72949d613713091";
  };

  patches = [ ./pam-service-name.patch ./lshd-no-root-login.patch ];

  preConfigure = ''
    # Patch `lsh-make-seed' so that it can gather enough entropy.
    sed -i "src/lsh-make-seed.c" \
        -e "s|/usr/sbin/arp|${nettools}/sbin/arp|g ;
            s|/usr/bin/netstat|${nettools}/bin/netstat|g ;
            s|/usr/local/bin/lsof|${lsof}/bin/lsof|g ;
            s|/bin/vmstat|${procps}/bin/vmstat|g ;
            s|/bin/ps|${procps}/bin/sp|g ;
            s|/usr/bin/w|${procps}/bin/w|g ;
            s|/usr/bin/df|$(type -P df)|g ;
            s|/usr/bin/ipcs|$(type -P ipcs)|g ;
            s|/usr/bin/uptime|$(type -P uptime)|g"

    # Skip the `configure' script that checks whether /dev/ptmx & co. work as
    # expected, because it relies on impurities (for instance, /dev/pts may
    # be unavailable in chroots.)
    export lsh_cv_sys_unix98_ptys=yes
  '';

  # -fcommon: workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: liblsh.a(unix_user.o):/build/lsh-2.0.4/src/server_userauth.h:108: multiple definition of
  #     `server_userauth_none_preauth'; lshd.o:/build/lsh-2.0.4/src/server_userauth.h:108: first defined here
  # Should be present in upcoming 2.1 release.
  env.NIX_CFLAGS_COMPILE = "-std=gnu90 -fcommon";

  buildInputs = [ gperf guile gmp zlib liboop readline gnum4 pam libxcrypt ];

  meta = {
    description = "GPL'd implementation of the SSH protocol";

    longDescription = ''
      lsh is a free implementation (in the GNU sense) of the ssh
      version 2 protocol, currently being standardised by the IETF
      SECSH working group.
    '';

    homepage = "http://www.lysator.liu.se/~nisse/lsh/";
    license = lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
