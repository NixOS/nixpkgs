{ lib, stdenv, fetchFromGitLab, substituteAll, autoreconfHook, iodine, intltool, pkg-config, networkmanager, libsecret, gtk3, gtk4
, withGnome ? true, gnome, fetchpatch, libnma, libnma-gtk4, glib }:

let
  pname = "NetworkManager-iodine";
  version = "unstable-2022-07-28";
in stdenv.mkDerivation {
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-iodine";
    rev = "db0fcb2e7d9a6ea1e344bbe4500275ea10c9059c";
    sha256 = "sha256-o8RI9re1MvXkc0UD3qq1d0sIKHMVDeK7gzbPiukI8wU=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/network-manager-iodine/-/commit/8ca3e0dca7d2543622e8d899445a1c348db490f4.diff";
      sha256 = "sha256-mG4Jv4pnYrithKkhWlp0x2iAGExlqqeGewA5jUX2w0M=";
    })
    (substituteAll {
      src = ./fix-paths.patch;
      inherit iodine;
    })
  ];

  buildInputs = [ iodine networkmanager glib ]
    ++ lib.optionals withGnome [ gtk3 gtk4 libsecret libnma-gtk4 ];

  nativeBuildInputs = [ intltool autoreconfHook pkg-config ];

  # glib-2.62 deprecations
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  preConfigure = "intltoolize";
  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-iodine";
    };
    networkManagerPlugin = "VPN/nm-iodine-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
