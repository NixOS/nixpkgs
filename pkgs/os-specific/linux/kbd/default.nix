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
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kbd/${pname}-${version}.tar.xz";
    sha256 = "17wvrqz2kk0w87idinhyvd31ih1dp7ldfl2yfx7ailygb0279w2m";
  };

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
