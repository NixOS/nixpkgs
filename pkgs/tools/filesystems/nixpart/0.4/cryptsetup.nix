{ stdenv, fetchurl, fetchpatch, lvm2, libgcrypt, libuuid, pkgconfig, popt
, enablePython ? true, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.6.3";

  src = fetchurl {
    url = "http://cryptsetup.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1n1qk5chyjspbiianrdb55fhb4wl0vfyqz2br05vfb24v4qlgbx2";
  };

  patches = [
    # Fix build with glibc >= 2.28
    # https://github.com/NixOS/nixpkgs/issues/86403
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/cryptsetup/files/cryptsetup-1.7.1-sysmacros.patch?id=d72316f97ebcc7fe622b21574442a9ac59b9115f";
      sha256 = "0xbhazgl44bimqhcrhajk016w9wi7bkrgwyfq13xmrvyrllqvgdx";
    })
  ];

  configureFlags = [ "--enable-cryptsetup-reencrypt" ]
                ++ stdenv.lib.optional enablePython "--enable-python";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lvm2 libgcrypt libuuid popt ]
             ++ stdenv.lib.optional enablePython python;

  meta = {
    homepage = "http://code.google.com/p/cryptsetup/";
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
