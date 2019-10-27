{ stdenv, fetchurl, lvm2, libgcrypt, libuuid, pkgconfig, popt
, enablePython ? true, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-1.6.3";

  src = fetchurl {
    url = "http://cryptsetup.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1n1qk5chyjspbiianrdb55fhb4wl0vfyqz2br05vfb24v4qlgbx2";
  };

  configureFlags = [ "--enable-cryptsetup-reencrypt" ]
                ++ stdenv.lib.optional enablePython "--enable-python";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lvm2 libgcrypt libuuid popt ]
             ++ stdenv.lib.optional enablePython python;

  meta = {
    homepage = http://code.google.com/p/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
