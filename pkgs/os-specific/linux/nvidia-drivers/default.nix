{ stdenv, fetchurl

, buildConfig ? "all"
, channel ? null

# Kernelspace dependencies
, kernel ? null
, nukeReferences

# Userspace dependencies
, xlibs
, zlib

, libsOnly ? false

, nvidiasettingsSupport ? true
  , atk ? null
  , gdk_pixbuf ? null
  , glib ? null
  , pango ? null
  , gtk2Support ? false
    , gtk2 ? null
  , gtk3Support ? true
    , gtk3 ? null
    , cairo ? null
}:

# NOTICE:
# - ONLY versions 304+ are supported on NixOS

# SHORTLIVED:  355.xx,   xorg <=1.17.x, kernel <=4.2
# LONGLIVED:   352.xx,   xorg <=1.17.x, kernel <=4.2 (stable) <- default
# LEGACY:      340.xx,   xorg <=1.17.x, kernel <=4.2
# LEGACY:      304.xx,   xorg <=1.17.x, kernel <=3.16
# UNSUPPORTED: 173.14.x, xorg <=1.15.x, kernel <=3.13
# UNSUPPORTED: 96.43.x,  xorg <=1.12.x, kernel <=3.7
# UNSUPPORTED: 71.86.x,  xorg <=?,      kernel <=?

# If your gpu requires a version that is unsupported it is recommended to use
# the nouveau driver.

let
  inherit (stdenv)
    system
    isx86_64;
  inherit (stdenv.lib)
    any
    makeLibraryPath
    optionals
    optionalString
    versionAtLeast
    versionOlder;
  sources = builtins.getAttr channel (import ./sources.nix);
  inherit (sources)
    versionMajor
    versionMinor
    sha256i686
    sha256x86_64;
  version = "${versionMajor}.${versionMinor}";
  buildKernelspace = any (n: n == buildConfig) [ "kernelspace" "all" ];
  buildUserspace = any (n: n == buildConfig) [ "userspace" "all" ];
in

assert any (n: n == buildConfig) [
  "kernelspace"
  "userspace"
  "all"
];
assert any (n: n == channel) [
  "legacy304"
  "legacy340"
  "long-lived"
  "short-lived"
  "testing"
];
assert buildKernelspace -> kernel != null;
assert nvidiasettingsSupport -> (
  atk != null &&
  gdk_pixbuf != null &&
  glib != null &&
  pango != null && 
  (gtk3Support || gtk2Support)
);
assert gtk2Support -> (
  gtk2 != null &&
  !gtk3Support &&
  cairo == null &&
  gtk3 == null
);
assert gtk3Support  -> (
  versionAtLeast versionMajor "346" &&
  cairo != null &&
  gtk3 != null &&
  !gtk2Support &&
  gtk2 == null
);
assert libsOnly -> !buildKernelspace;

stdenv.mkDerivation {

  name = "nvidia-drivers-${buildConfig}-${version}"
       + "${optionalString buildKernelspace "-${kernel.version}"}";

  src = fetchurl {
    url =
      if system == "i686-linux" then
        "http://us.download.nvidia.com/XFree86/Linux-x86/${version}/" +
        "NVIDIA-Linux-x86-${version}.run"
      else if system == "x86_64-linux" then
        "http://us.download.nvidia.com/XFree86/Linux-x86_64/${version}/" +
        "NVIDIA-Linux-x86_64-${version}-no-compat32.run"
      else
        throw "The NVIDIA drivers do not support the `${system}' platform";
    sha256 =
      if system == "i686-linux" then
        sha256i686
      else if system == "x86_64-linux" then
        sha256x86_64
      else
        throw "The NVIDIA drivers do not support the `${system}' platform";
  };

  kernel =
    if buildKernelspace then
      kernel.dev
    else
      null;

  disallowedReferences =
    if buildKernelspace then
      [ kernel.dev ]
    else
      [ ];

  patches =
    optionals (versionAtLeast versionMajor "346" &&
               versionOlder versionMajor "355") [
      ./nvidia-4.2.patch
    ];

  # Make sure anything that isn't declared within the derivation
  # is inherited so that it is passed to the builder.
  inherit
    buildKernelspace
    buildUserspace
    libsOnly
    gtk3Support
    nvidiasettingsSupport
    version
    versionMajor;

  nativeBuildInputs = [ nukeReferences ];

  builder = ./builder.sh;

  dontStrip = true;

  glPath = makeLibraryPath [
    xlibs.libXext
    xlibs.libX11
    xlibs.libXrandr
  ];
  programPath = makeLibraryPath [
    xlibs.libXv
  ];
  allLibPath = makeLibraryPath [
    stdenv.cc.cc
    xlibs.libX11
    xlibs.libXext
    xlibs.libXrandr
    zlib
  ];
  gtkPath = optionalString (!libsOnly) (
    makeLibraryPath (
      [
        atk
        pango
        glib
        gdk_pixbuf
      ] ++ (
        if gtk3Support then [
          cairo
          gtk3
        ] else [
          gtk2
        ]
      )
    )
  );

  passthru = {
    inherit
      version
      versionMajor;
    nvenc =
      if versionAtLeast versionMajor "340" then
        true
      else
        false;
    cudaUVM =
      if ((versionAtLeast versionMajor "340" &&
           versionOlder versionMajor "346") ||
          (versionAtLeast versionMajor "346" &&
           isx86_64)) then
        true
      else
        false;
  };

  meta = with stdenv.lib; {
    description = "Drivers and Linux kernel modules for NVIDIA graphics cards";
    homepage = http://www.nvidia.com/object/unix.html;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [
      codyopel
      vcunat
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    # Resolves collision w/ xorg-server "lib/xorg/modules/extensions/libglx.so"
    priority = 4;
  };
}
