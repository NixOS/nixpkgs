{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "ddrutility";
  version = "2.8";

  src = fetchurl {
    url = "mirror://sourceforge/ddrutility/${pname}-${version}.tar.gz";
    sha256 = "023g7f2sfv5cqk3iyss4awrw3b913sy5423mn5zvlyrri5hi2cac";
  };

  postPatch = ''
    substituteInPlace makefile --replace /usr/local ""
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: /build/ccltHly5.o:(.bss+0x119f8): multiple definition of `start_time'; /build/cc9evx3L.o:(.bss+0x10978): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "A set of utilities for hard drive data rescue";
    homepage = "https://sourceforge.net/projects/ddrutility/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
