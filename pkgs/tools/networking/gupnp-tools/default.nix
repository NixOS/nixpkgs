{ stdenv
, lib
, fetchurl
, meson
, ninja
, gupnp_1_6
, libsoup_3
, gssdp_1_6
, pkg-config
, gtk3
, gettext
, gupnp-av
, gtksourceview4
, gnome
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gupnp-tools";
<<<<<<< HEAD
  version = "0.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "U8+TEj85fo+PC46eQ2TIanUCpTNPTAvi4FSoJEeL1bo=";
=======
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "XqdgfuNlZCxVWSf+3FteH+COdPBh0MPrCL2QG16yAII=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gupnp_1_6
    libsoup_3
    gssdp_1_6
    gtk3
    gupnp-av
    gtksourceview4
  ];

<<<<<<< HEAD
  # new libxml2 version
  # TODO: can be dropped on next update
  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Set of utilities and demos to work with UPnP";
    homepage = "https://wiki.gnome.org/Projects/GUPnP";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
