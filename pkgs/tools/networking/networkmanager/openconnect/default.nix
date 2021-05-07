{ lib, stdenv
, fetchurl
, substituteAll
, glib
, libxml2
, openconnect
, intltool
, pkg-config
, autoreconfHook
, networkmanager
, gcr
, libsecret
, file
, gtk3
, withGnome ? true
, gnome
, kmod
, fetchpatch
}:

let
  pname = "NetworkManager-openconnect";
  version = "1.2.6";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0nlp290nkawc4wqm978n4vhzg3xdqi8kpjjx19l855vab41rh44m";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openconnect;
    })

    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/NetworkManager-openconnect/merge_requests/9.patch";
      sha256 = "0yd2dmq6gq6y4czr7dqdgaiqvw2vyv2gikznpfdxyfn2v1pcrk9m";
    })
  ];

  buildInputs = [
    glib
    libxml2
    openconnect
    networkmanager
  ] ++ lib.optionals withGnome [
    gtk3
    gcr
    libsecret
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
    file
  ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
    "--without-libnm-glib"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openconnect";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "NetworkManager’s OpenConnect plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
