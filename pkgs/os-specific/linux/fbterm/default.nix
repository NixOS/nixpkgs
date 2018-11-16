{stdenv, lib, fetchurl, gpm, freetype, fontconfig, pkgconfig, ncurses, libx86}:
let
  s = # Generated upstream information
  rec {
    baseName="fbterm";
    version="1.7.0";
    name="fbterm-1.7.0";
    hash="0pciv5by989vzvjxsv1jsv4bdp4m8j0nfbl29jm5fwi12w4603vj";
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/fbterm/fbterm-1.7.0.tar.gz";
    sha256="0pciv5by989vzvjxsv1jsv4bdp4m8j0nfbl29jm5fwi12w4603vj";
  };
  buildInputs = [gpm freetype fontconfig ncurses]
    ++ lib.optional (stdenv.isi686 || stdenv.isx86_64) libx86;
in
stdenv.mkDerivation {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };

  nativeBuildInputs = [ pkgconfig ];
  inherit buildInputs;

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
  ];

  meta = with stdenv.lib; {
    inherit (s) version;
    description = "Framebuffer terminal emulator";
    homepage = https://code.google.com/archive/p/fbterm/;
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
