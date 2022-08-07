{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libtool, pam, libHX, libxml2, pcre2, perl, openssl, cryptsetup, util-linux }:

stdenv.mkDerivation rec {
  pname = "pam_mount";
  version = "2.19";

  src = fetchurl {
    url = "mirror://sourceforge/pam-mount/pam_mount/${pname}-${version}.tar.xz";
    sha256 = "02m6w04xhgv2yx69yxph8giw0sp39s9lvvlffslyna46fnr64qvb";
  };

  patches = [
    ./insert_utillinux_path_hooks.patch
  ];

  postPatch = ''
    substituteInPlace src/mtcrypt.c \
      --replace @@NIX_UTILLINUX@@ ${util-linux}/bin
  '';

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];

  buildInputs = [ pam libHX util-linux libxml2 pcre2 perl openssl cryptsetup ];

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
    maintainers = with maintainers; [ netali ];
    platforms = platforms.linux;
  };
}
