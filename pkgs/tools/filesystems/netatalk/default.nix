{ fetchurl, lib, stdenv, autoreconfHook, pkg-config, perl, python3, db
, libgcrypt, avahi, libiconv, pam, openssl, acl, ed, libtirpc, libevent
, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "netatalk";
  version = "3.1.13";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${version}.tar.bz2";
    sha256 = "0pg0slvvvq3l6f5yjz9ybijg4i6rs5a6c8wcynaasf8vzsyadbc9";
  };

  patches = [
    ./no-suid.patch
    ./omitLocalstatedirCreation.patch
    (fetchpatch {
      name = "make-afpstats-python3-compatible.patch";
      url = "https://github.com/Netatalk/Netatalk/commit/916b515705cf7ba28dc53d13202811c6e1fe6a9e.patch";
      sha256 = "sha256-DAABpYjQPJLsQBhmtP30gA357w0Qn+AsnFgAeyDC/Rg=";
    })
  ];

  freeBSDPatches = [
    # https://bugs.freebsd.org/263123
    (fetchpatch {
      name = "patch-etc_afpd_directory.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_afpd_directory.c";
      sha256 = "sha256-07YAJs+EtqGcFXbYHDLbILved1Ebtd8ukQepvzy6et0=";
    })
    (fetchpatch {
      name = "patch-etc_afpd_file.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_afpd_file.c";
      sha256 = "sha256-T1WTNa2G6wxKtvMa/MCX3Vx6XZBHtU6w3enkdGuIWus=";
    })
    (fetchpatch {
      name = "patch-etc_afpd_volume.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_afpd_volume.c";
      sha256 = "sha256-NOZNZGzA0hxrNkoLTvN64h40yApPbMH4qIfBTpQoI0s=";
    })
    (fetchpatch {
      name = "patch-etc_cnid__dbd_cmd__dbd__scanvol.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_cnid__dbd_cmd__dbd__scanvol.c";
      sha256 = "sha256-5QV+tQDo8/XeKwH/e5+Ne+kEOl2uvRDbHMaWysIB6YU=";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__attr.c";
      url =
        "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__attr.c";
      sha256 = "sha256-Ose6BdilwBOmoYpm8Jat1B3biOXJj4y3U4T49zE0G7Y=";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__conv.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__conv.c";
      sha256 = "sha256-T27WlKVXosv4bX5Gek2bR2cVDYEee5qrH4mnL9ghbP8=";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__date.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__date.c";
      sha256 = "sha256-fkW5A+7R5fT3bukRfZaOwFo7AsyPaYajc1hIlDMZMnc=";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__flush.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__flush.c";
      sha256 = "sha256-k2zTx35tAlsFHym83bZGoWXRomwFV9xT3r2fzr3Zvbk=";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__open.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__open.c";
      sha256 = "sha256-uV4wwft2IH54+4k5YR+Gz/BpRZBanxX/Ukp8BkohInU=";
    })
    # https://bugs.freebsd.org/251203
    (fetchpatch {
      name = "patch-libatalk_vfs_extattr.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_vfs_extattr.c";
      sha256 = "sha256-lFWF0Qo8PJv7QKvnMn0Fc9Ruzb+FTEWgOMpxc789jWs=";
    })
  ];

  postPatch = ''
    # freeBSD patches are -p0
    for i in $freeBSDPatches ; do
      patch -p0 < $i
    done
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config perl python3 python3.pkgs.wrapPython ];

  buildInputs = [ db libgcrypt avahi libiconv pam openssl acl libevent ];

  configureFlags = [
    "--with-bdb=${db.dev}"
    "--with-ssl-dir=${openssl.dev}"
    "--with-lockfile=/run/lock/netatalk"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var/lib"
  ];

  # Expose librpcsvc to the linker for afpd
  # Fixes errors that showed up when closure-size was merged:
  # afpd-nfsquota.o: In function `callaurpc':
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_args'
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_rslt'
  postConfigure = ''
    ${ed}/bin/ed -v etc/afpd/Makefile << EOF
    /^afpd_LDADD
    /am__append_2
    a
      ${libtirpc}/lib/libtirpc.so \\
    .
    w
    EOF
  '';

  postInstall = ''
    buildPythonPath ${python3.pkgs.dbus-python}
    patchPythonScript $out/bin/afpstats
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Apple Filing Protocol Server";
    homepage = "http://netatalk.sourceforge.net/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
