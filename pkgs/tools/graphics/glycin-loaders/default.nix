{ stdenv
, lib
, fetchFromGitLab
, cargo
, git
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, gtk4
, libheif
, libxml2
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "glycin-loaders";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "sophie-h";
    repo = "glycin";
    rev = version;
    hash = "sha256-XT3i0GQsLC2sMLHpaEzbItauX/8327wdlVt0/WHkCeo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-HRBR+FWI87FCtDlJ3VvwT/7QFG/L7PYliX7mBYPy3aM=";
  };

  nativeBuildInputs = [
    cargo
    git
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libheif
    libxml2 # for librsvg crate
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/sophie-h/glycin";
    maintainers = teams.gnome.members;
    license = with licenses; [ mpl20 /* or */ lgpl21Plus ];
    platforms = platforms.linux;
  };
}
