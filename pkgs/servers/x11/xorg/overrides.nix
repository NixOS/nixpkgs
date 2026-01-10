{
  callPackage,
  lib,
  config,
  stdenv,
  makeWrapper,
  fetchurl,
  fetchpatch,
  fetchFromGitLab,
  buildPackages,
  automake,
  autoconf,
  libiconv,
  libtool,
  intltool,
  gettext,
  gzip,
  python3,
  perl,
  freetype,
  tradcpp,
  fontconfig,
  meson,
  ninja,
  ed,
  fontforge,
  libGL,
  spice-protocol,
  zlib,
  libGLU,
  dbus,
  libunwind,
  libdrm,
  netbsd,
  ncompress,
  updateAutotoolsGnuConfigScriptsHook,
  mesa,
  udev,
  bootstrap_cmds,
  bison,
  flex,
  clangStdenv,
  autoreconfHook,
  mcpp,
  libepoxy,
  openssl,
  pkg-config,
  llvm,
  libxslt,
  libxcrypt,
  hwdata,
  xorg,
  windows,
  libgbm,
  mesa-gl-headers,
  dri-pkgconfig-stub,
}:
self: super:
{
  mkfontdir = xorg.mkfontscale;
}
# deprecate some packages
// lib.optionalAttrs config.allowAliases {
  fontbitstreamspeedo = throw "Bitstream Speedo is an obsolete font format that hasn't been supported by Xorg since 2005"; # added 2025-09-24
  libXtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
  xtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
  xf86videoglide = throw "The Xorg Glide video driver has been archived upstream due to being obsolete"; # added 2025-12-13
  xf86videoglint = throw ''
    The Xorg GLINT/Permedia video driver has been broken since xorg 21.
    see https://gitlab.freedesktop.org/xorg/driver/xf86-video-glint/-/issues/1
  ''; # added 2025-12-13
  xf86videonewport = throw "The Xorg Newport video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xf86videotga = throw "The Xorg TGA (aka DEC 21030) video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xf86videowsfb = throw "The Xorg BSD wsdisplay framebuffer video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
}
