{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-${version}";
  version = "4.0";

  src = fetchurl {
    sha256 = "1bvxbv1w6vhbx0nx7ygp700wq5k2hjv0hm7w0kz1x7amaf4p6dwh";
    url = "https://github.com/dosfstools/dosfstools/releases/download/v${version}/${name}.tar.xz";
  };

  configureFlags = [ "--enable-compat-symlinks" ];

  meta = with stdenv.lib; {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
