{
  lib,
  stdenv,
  fetchFromGitLab,
  substituteAll,
  autoreconfHook,
  iodine,
  intltool,
  pkg-config,
  networkmanager,
  libsecret,
  gtk3,
  withGnome ? true,
  unstableGitUpdater,
  libnma,
  glib,
}:

stdenv.mkDerivation {
  pname = "NetworkManager-iodine${lib.optionalString withGnome "-gnome"}";
  version = "1.2.0-unstable-2024-05-12";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "network-manager-iodine";
    rev = "8ec0a35e12047ccf256b3951897c701661ddb8af";
    sha256 = "cNjznry8wi1UmE5khf0JCEYjs9nDU/u8lFLte53MLTM=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit iodine;
    })
  ];

  nativeBuildInputs = [
    intltool
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    [
      iodine
      networkmanager
      glib
    ]
    ++ lib.optionals withGnome [
      gtk3
      libsecret
      libnma
    ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  preConfigure = ''
    intltoolize
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };

    networkManagerPlugin = "VPN/nm-iodine-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
