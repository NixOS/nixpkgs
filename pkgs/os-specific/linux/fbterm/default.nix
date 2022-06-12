{ stdenv, lib, fetchurl, gpm, freetype, fontconfig, pkg-config, ncurses, libx86 }:

stdenv.mkDerivation rec {
  version = "1.7.0";
  pname = "fbterm";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/fbterm/fbterm-${version}.tar.gz";
    sha256 = "0pciv5by989vzvjxsv1jsv4bdp4m8j0nfbl29jm5fwi12w4603vj";
  };

  nativeBuildInputs = [ pkg-config ncurses ];
  buildInputs = [ gpm freetype fontconfig ncurses ]
    ++ lib.optional stdenv.hostPlatform.isx86 libx86;

  preConfigure = ''
    sed -e '/ifdef SYS_signalfd/atypedef long long loff_t;' -i src/fbterm.cpp
    sed -e '/install-exec-hook:/,/^[^\t]/{d}; /.NOEXPORT/iinstall-exec-hook:\
    ' -i src/Makefile.in
    export HOME=$PWD;
    export NIX_LDFLAGS="$NIX_LDFLAGS -lfreetype"
  '';
  preBuild = ''
    mkdir -p "$out/share/terminfo"
    tic -a -v2 -o"$out/share/terminfo" terminfo/fbterm
    makeFlagsArray+=("AR=$AR")
  '';

  patches = [
    # fixes from Arch Linux package
    (fetchurl {
      url = "https://raw.githubusercontent.com/glitsj16/fbterm-patched/d1fe03313be4654dd0a1c0bb5f51530732345134/gcc-6-build-fixes.patch";
      sha256 = "1kl9fjnrri6pamjdl4jpkqxk5wxcf6jcchv5801xz8vxp4542m40";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/glitsj16/fbterm-patched/d1fe03313be4654dd0a1c0bb5f51530732345134/insertmode-fix.patch";
      sha256 = "1bad9mqcfpqb94lpx23lsamlhplil73ahzin2xjva0gl3gr1038l";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/glitsj16/fbterm-patched/d1fe03313be4654dd0a1c0bb5f51530732345134/miscoloring-fix.patch";
      sha256 = "1mjszji0jgs2jsagjp671fv0d1983wmxv009ff1jfhi9pbay6jd0";
    })
    ./select.patch
  ];

  meta = with lib; {
    description = "Framebuffer terminal emulator";
    homepage = "https://code.google.com/archive/p/fbterm/";
    maintainers = with maintainers; [ raskin ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
