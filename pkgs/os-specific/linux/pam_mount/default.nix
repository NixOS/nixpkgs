{ stdenv, fetchurl, autoreconfHook, pkgconfig, libtool, pam, libHX, libxml2, pcre, perl, openssl, cryptsetup, utillinux }:

stdenv.mkDerivation rec {
  pname = "pam_mount";
  version = "2.16";

  src = fetchurl {
    url = "mirror://sourceforge/pam-mount/pam_mount/${version}/${pname}-${version}.tar.xz";
    sha256 = "1rvi4irb7ylsbhvx1cr6islm2xxw1a4b19q6z4a9864ndkm0f0mf";
  };

  patches = [
    ./insert_utillinux_path_hooks.patch
    ./support_luks2.patch
  ];

  postPatch = ''
    substituteInPlace src/mtcrypt.c \
      --replace @@NIX_UTILLINUX@@ ${utillinux}/bin
  '';

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig ];

  buildInputs = [ pam libHX utillinux libxml2 pcre perl openssl cryptsetup ];

  enableParallelBuilding = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--localstatedir=${placeholder "out"}/var"
    "--sbindir=${placeholder "out"}/bin"
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-slibdir=${placeholder "out"}/lib"
    "--with-ssbindir=${placeholder "out"}/bin"
  ];

  postInstall = ''
    rm -r $out/var
  '';

  meta = with stdenv.lib; {
    description = "PAM module to mount volumes for a user session";
    homepage = "https://pam-mount.sourceforge.net/";
    license = with licenses; [ gpl2 gpl3 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}
