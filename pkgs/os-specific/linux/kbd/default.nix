{ stdenv, fetchurl, autoreconfHook,
  gzip, bzip2, pkgconfig, flex, check,
  pam, coreutils
}:

stdenv.mkDerivation rec {
  pname = "kbd";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kbd/${pname}-${version}.tar.xz";
    sha256 = "124swm93dm4ca0pifgkrand3r9gvj3019d4zkfxsj9djpvv0mnaz";
  };

  configureFlags = [
    "--enable-optional-progs"
    "--enable-libkeymap"
    "--disable-nls"
  ];

  patches = [ ./search-paths.patch ];

  postPatch =
    ''
      # Add Neo keymap subdirectory
      sed -i -e 's,^KEYMAPSUBDIRS *= *,&i386/neo ,' data/Makefile.am

      # Renaming keymaps with name clashes, because loadkeys just picks
      # the first keymap it sees. The clashing names lead to e.g.
      # "loadkeys no" defaulting to a norwegian dvorak map instead of
      # the much more common qwerty one.
      pushd data/keymaps/i386
      mv qwertz/cz{,-qwertz}.map
      mv olpc/es{,-olpc}.map
      mv olpc/pt{,-olpc}.map
      mv dvorak/{no.map,dvorak-no.map}
      mv fgGIod/trf{,-fgGIod}.map
      mv colemak/{en-latin9,colemak}.map
      popd

      # Fix the path to gzip/bzip2.
      substituteInPlace src/libkeymap/findfile.c \
        --replace gzip ${gzip}/bin/gzip \
        --replace bzip2 ${bzip2.bin}/bin/bzip2 \

      # We get a warning in armv5tel-linux and the fuloong2f, so we
      # disable -Werror in it.
      ${stdenv.lib.optionalString (stdenv.isAarch32 || stdenv.hostPlatform.isMips) ''
        sed -i s/-Werror// src/Makefile.am
      ''}
    '';

  postInstall = ''
    for i in $out/bin/unicode_{start,stop}; do
      substituteInPlace "$i" \
        --replace /usr/bin/tty ${coreutils}/bin/tty
    done
  '';


  buildInputs = [ check pam ];
  nativeBuildInputs = [ autoreconfHook pkgconfig flex ];

  makeFlags = [ "setowner=" ];

  meta = with stdenv.lib; {
    homepage = "ftp://ftp.altlinux.org/pub/people/legion/kbd/";
    description = "Linux keyboard utilities and keyboard maps";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
