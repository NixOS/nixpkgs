{ lib, stdenv, fetchFromGitLab, substituteAll, autoreconfHook, iodine, intltool, pkg-config, networkmanager, libsecret, gtk3
, withGnome ? true, gnome, fetchpatch, libnma, glib }:

let
  pname = "NetworkManager-iodine";
  version = "unstable-2019-11-05";
in stdenv.mkDerivation {
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-iodine";
    rev = "2ef0abf089b00a0546f214dde0d45e63f2990b79";
    sha256 = "1ps26fr9b1yyafj7lrzf2kmaxb0ipl0mhagch5kzrjdsc5xkajz7";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit iodine;
    })
    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/network-manager-iodine/merge_requests/2.patch";
      sha256 = "108pkf0mddj32s46k7jkmpwcaq2ylci4dqpp7wck3zm9q2jffff2";
    })
  ];

  buildInputs = [ iodine networkmanager glib ]
    ++ lib.optionals withGnome [ gtk3 libsecret libnma ];

  nativeBuildInputs = [ intltool autoreconfHook pkg-config ];

  # glib-2.62 deprecations
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  preConfigure = "intltoolize";
  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
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
