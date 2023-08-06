{ lib
, stdenv
, fetchurl
, nixosTests
, autoreconfHook
, pkg-config
, flex
, check
, pam
, coreutils
, gzip
, bzip2
, xz
, zstd
}:

stdenv.mkDerivation rec {
  pname = "kbd";
  version = "2.5.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kbd/${pname}-${version}.tar.xz";
    sha256 = "sha256-zN9FI4emOAlz0pJzY+nLuTn6IGiRWm+Tf/nSRSICRoM=";
  };

  # vlock is moved into its own output, since it depends on pam. This
  # reduces closure size for most use cases.
  outputs = [ "out" "vlock" "dev" ];

  configureFlags = [
    "--enable-optional-progs"
    "--enable-libkeymap"
    "--disable-nls"
  ];

  patches = [
    ./search-paths.patch
  ];

  postPatch =
    ''
      # Renaming keymaps with name clashes, because loadkeys just picks
      # the first keymap it sees. The clashing names lead to e.g.
      # "loadkeys no" defaulting to a norwegian dvorak map instead of
      # the much more common qwerty one.
      pushd data/keymaps/i386
      mv qwertz/cz{,-qwertz}.map
      mv olpc/es{,-olpc}.map
      mv olpc/pt{,-olpc}.map
      mv fgGIod/trf{,-fgGIod}.map
      mv colemak/{en-latin9,colemak}.map
      popd

      # Fix paths to decompressors. Trailing space to avoid replacing `xz` in `".xz"`.
      substituteInPlace src/libkbdfile/kbdfile.c \
        --replace 'gzip '  '${gzip}/bin/gzip ' \
        --replace 'bzip2 ' '${bzip2.bin}/bin/bzip2 ' \
        --replace 'xz '    '${xz.bin}/bin/xz ' \
        --replace 'zstd '  '${zstd.bin}/bin/zstd '

      sed -i '
        1i prefix:=$(vlock)
        1i bindir := $(vlock)/bin' \
        src/vlock/Makefile.in \
        src/vlock/Makefile.am
    '';

  postInstall = ''
    for i in $out/bin/unicode_{start,stop}; do
      substituteInPlace "$i" \
        --replace /usr/bin/tty ${coreutils}/bin/tty
    done
  '';

  buildInputs = [ check pam ];
  NIX_LDFLAGS = lib.optional stdenv.hostPlatform.isStatic "-laudit";
  nativeBuildInputs = [ autoreconfHook pkg-config flex ];

  passthru.tests = {
    inherit (nixosTests) keymap kbd-setfont-decompress kbd-update-search-paths-patch;
  };
  passthru.gzip = gzip;

  meta = with lib; {
    homepage = "https://kbd-project.org/";
    description = "Linux keyboard tools and keyboard maps";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ davidak ];
  };
}
