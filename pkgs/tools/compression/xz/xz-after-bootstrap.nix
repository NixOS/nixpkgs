{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  perl,
  libtool,
  gettext,
  perl538Packages,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xz";
  version = xz.version;

  src = fetchFromGitHub {
    owner = "tukaani-project";
    repo = "xz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Xp1uLtQIoOG/qVLpq5D/KFmTOJ0+mNkNclyuJsvlUbE=";
  };

  strictDeps = true;

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeBuildInputs = [
    gettext
    libtool
    automake
    autoconf
    perl
    perl538Packages.Po4a
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  postPhases = [ "compareArtifacts" ];

  compareArtifacts = ''
    diff $out/lib/liblzma.so ${xz.out}/lib/liblzma.so
  '';

  meta = with lib; {
    changelog = "https://github.com/tukaani-project/xz/releases/tag/v${finalAttrs.version}";
    description = "General-purpose data compression software, successor of LZMA";
    homepage = "https://tukaani.org/xz/";
    longDescription = ''
      XZ Utils is free general-purpose data compression software with high
      compression ratio.  XZ Utils were written for POSIX-like systems,
      but also work on some not-so-POSIX systems.  XZ Utils are the
      successor to LZMA Utils.

      The core of the XZ Utils compression code is based on LZMA SDK, but
      it has been modified quite a lot to be suitable for XZ Utils.  The
      primary compression algorithm is currently LZMA2, which is used
      inside the .xz container format.  With typical files, XZ Utils
      create 30 % smaller output than gzip and 15 % smaller output than
      bzip2.

      Note that this is the version built after the bootstrap of nixpkgs.
    '';
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with maintainers; [ julienmalka ];
    platforms = platforms.all;
    pkgConfigModules = [ "liblzma" ];
  };
})
