{ lib, stdenv, fetchurl, perl, libtool, pkg-config, gettext, mandoc, ed }:

stdenv.mkDerivation rec {
  pname = "bsdbuild";
  version = "3.1";

  src = fetchurl {
    url = "http://stable.hypertriton.com/bsdbuild/${pname}-${version}.tar.gz";
    sha256 = "1zrdjh7a6z4khhfw9zrp490afq306cpl5v8wqz2z55ys7k1n5ifl";
  };

  buildInputs = [ perl mandoc ed ];
  nativeBuildInputs = [ pkg-config libtool gettext ];

  prePatch = ''
    #ignore unfamiliar flags
    substituteInPlace configure \
      --replace '--sbindir=*' '--sbindir=* | --includedir=* | --oldincludedir=*'
    #same for packages using bsdbuild
    substituteInPlace mkconfigure.pl \
      --replace '--sbindir=*' '--sbindir=* | --includedir=* | --oldincludedir=*'
    #insert header for missing NULL macro
    for f in db4.pm sdl_ttf.pm mysql.pm uim.pm strlcpy.pm getpwuid.pm \
      getaddrinfo.pm strtoll.pm free_null.pm getpwnam_r.pm \
      gettimeofday.pm gethostbyname.pm xinerama.pm strsep.pm \
      fontconfig.pm gettext.pm pthreads.pm strlcat.pm kqueue.pm wgl.pm \
      alsa.pm crypt.pm cracklib.pm freesg-rg.pm edacious.pm mmap.pm \
      agar.pm x11.pm x11.pm execvp.pm agar-core.pm dyld.pm getopt.pm \
      strtold.pm sdl_image.pm shl_load.pm glx.pm percgi.pm timerfd.pm \
      glob.pm dlopen.pm freesg.pm csidl.pm perl.pm select.pm \
      portaudio.pm etubestore.pm;
    do
ed -s -v BSDBuild/$f << EOF
/#include
i
#include <stddef.h>
.
w
EOF
    done
  '';

  configureFlags = [
    "--with-libtool=${libtool}/bin/libtool"
    "--enable-nls=yes"
    "--with-gettext=${gettext}"
    "--with-manpages=yes"
  ];

  meta = {
    homepage = "http://bsdbuild.hypertriton.com";
    description = "Cross-platform build system";

    longDescription = ''
      BSDBuild is a cross-platform build system. Derived from the
      traditional 4.4BSD make libraries, BSDBuild allows BSD-style
      Makefiles (without BSD make extensions), and works natively
      under most operating systems and make flavors. Since BSDBuild
      is implemented as a library (as opposed to a macro package),
      Makefiles are edited directly, as opposed to being compiled
      (however, if the build directory is separate from the source
      directory, BSDBuild will produce the required Makefiles in place).
    '';

    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
