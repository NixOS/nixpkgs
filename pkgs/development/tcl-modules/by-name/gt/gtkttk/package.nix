{
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mkTclDerivation,
  tk,
  gtk2,
  gtk_engines,
  gdk-pixbuf-xlib,
  nix-update-script,
}:
mkTclDerivation rec {
  pname = "gtkttk";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "Geballin";
    repo = "gtkTtk";
    tag = version;
    hash = "sha256-gSqd9FatF4q06r5TrhSGVJ+vh0ybNv8/9AP68v7pW1E=";
  };

  # Tk's private headers are required but Tk's src is a tarball, so it needs to be unpacked
  postUnpack = ''
    unpackFile "${tk.src}"
  '';

  # Do not load GTK dynamically because it relies on hard-coded paths for library directories
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'SET ( LOAD_GTK_DYNAMICALLY ON )' 'SET ( LOAD_GTK_DYNAMICALLY OFF )'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];
  preBuild = ''
    NIX_CFLAGS_COMPILE+=" \
    -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0 \
    -I$NIX_BUILD_TOP/tk${tk.version}/generic/ttk" \
  '';

  buildInputs = [
    cmake
    pkg-config
    tk
    gtk2
    gtk_engines
    gdk-pixbuf-xlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Geballin/gtkTtk";
    description = "TTK theme that gives Tk applications a native GTK look and feel";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
