{
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  fetchpatch,
  fetchurl,
  fontconfig,
  freetype,
  gpm,
  lib,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.7-2";
  pname = "fbterm";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = pname;
    rev = "debian/${version}";
    hash = "sha256-vRUZgFpA1IkzkLzl7ImT+Yff5XqjFbUlkHmj/hd7XDE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    ncurses
  ];
  buildInputs = [
    gpm
    freetype
    fontconfig
    ncurses
  ];

  makeFlags = [
    "AR:=$(AR)"
  ];

  # preConfigure = ''
  #   sed -e '/ifdef SYS_signalfd/atypedef long long loff_t;' -i src/fbterm.cpp
  #   sed -e '/install-exec-hook:/,/^[^\t]/{d}; /.NOEXPORT/iinstall-exec-hook:\
  #   ' -i src/Makefile.in
  #   export HOME=$PWD;
  #   export NIX_LDFLAGS="$NIX_LDFLAGS -lfreetype"
  # '';

  preInstall = ''
    export HOME=$PWD
  '';

  postInstall =
    let
      fbtermrc = fetchurl {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/fbtermrc?h=fbterm";
        hash = "sha256-zNIfi2ZjEGc5PLdOIirKGTXESb5Wm5XBAI1sfHa31LY=";
      };
    in
    ''
      mkdir -p "$out/share/terminfo"
      tic -a -v2 -o"$out/share/terminfo" terminfo/fbterm

      mkdir -p "$out/etc/fbterm"
      cp "${fbtermrc}" "$out/etc/fbterm"
    '';

  # Patches from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=fbterm
  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fbconfig.patch?h=fbterm";
      hash = "sha256-skCdUqyMkkqxS1YUI7cofsfnNNo3SL/qe4WEIXlhm/s=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/color_palette.patch?h=fbterm";
      hash = "sha256-SkWxzfapyBTtMpTXkiFHRAw8/uXw7cAWwg5Q3TqWlk8=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fbterm.patch?h=fbterm";
      hash = "sha256-XNHBTGQGeaQPip2XgcKlr123VDwils2pnyiGqkBGhzU=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-Fix-build-with-gcc-6.patch?h=fbterm";
      hash = "sha256-3d3zBvr5upICVVkd6tn63IhuB0sF67f62aKnf8KvOwg=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix_ftbfs_crosscompile.patch?h=fbterm";
      hash = "sha256-jv/FSG6dHR0jKjPXQIfqsvpiT/XYzwv/VwuV+qUSovM=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix_ftbfs_epoll.patch?h=fbterm";
      hash = "sha256-wkhfG0uY/5ZApcXTERkaKqz5IDpnilxUEcxull4645A=";
    })
  ];

  meta = with lib; {
    description = "Framebuffer terminal emulator";
    mainProgram = "fbterm";
    homepage = "https://salsa.debian.org/debian/fbterm";
    maintainers = with maintainers; [
      lovesegfault
      raskin
    ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
