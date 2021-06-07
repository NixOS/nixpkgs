{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libtool, pam, libHX, libxml2, pcre, perl, openssl, cryptsetup, util-linux }:

stdenv.mkDerivation rec {
  pname = "pam_mount";
  version = "2.17";

  src = fetchurl {
    url = "mirror://sourceforge/pam-mount/pam_mount/${pname}-${version}.tar.xz";
    sha256 = "1q2n6a2ah6nghdn8i6ad2wj247njwb5nx48cggxknaa6lqxylidy";
  };

  patches = [
    ./insert_utillinux_path_hooks.patch
  ];

  postPatch = ''
    substituteInPlace src/mtcrypt.c \
      --replace @@NIX_UTILLINUX@@ ${util-linux}/bin
  '';

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];

  buildInputs = [ pam libHX util-linux libxml2 pcre perl openssl cryptsetup ];

  enableParallelBuilding = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--localstatedir=${placeholder "out"}/var"
    "--sbindir=${placeholder "out"}/bin"
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-slibdir=${placeholder "out"}/lib"
  ];

  postInstall = ''
    rm -r $out/var
  '';

  meta = with lib; {
    description = "PAM module to mount volumes for a user session";
    homepage = "https://pam-mount.sourceforge.net/";
    license = with licenses; [ gpl2 gpl3 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}
