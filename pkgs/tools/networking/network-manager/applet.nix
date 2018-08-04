{ stdenv, fetchurl, fetchpatch, meson, ninja, intltool, gtk-doc, pkgconfig, networkmanager, gnome3
, libnotify, libsecret, polkit, isocodes, modemmanager, libxml2, docbook_xsl
, mobile-broadband-provider-info, glib-networking, gsettings-desktop-schemas
, libgudev, hicolor-icon-theme, jansson, wrapGAppsHook, webkitgtk, gobjectIntrospection
, libindicator-gtk3, libappindicator-gtk3, withGnome ? false }:

let
  pname = "network-manager-applet";
  version = "1.8.14";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1js0i2kwfklahsn77qgxzdscy33drrlym3mrj1qhlw0zf8ri56ya";
  };

  patches = [
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/network-manager-applet/merge_requests/12.patch;
      sha256 = "0q5qbjpbrfvhqsprnwjwz4c42nly59cgnbn41w2zlxvqf29gjvwk";
    })

    # following 3 patches:
    # https://gitlab.gnome.org/GNOME/network-manager-applet/issues/11
    # should be fixed in 1.8.16
    (fetchpatch {
      name = "0001-connection-editor-hold-GApplication-while-the-import.patch";
      url = https://gitlab.gnome.org/GNOME/network-manager-applet/commit/419c459e70ac752eb9226b0db1192fb0433d5d5e.patch;
      sha256 = "0zi4fn2ynymi6ckkdrj8vcl78pwmkan4n8l53axaqb4kn0wnahdj";
    })
    (fetchpatch {
      name = "0002-connection-list-attempt-a-VPN-import-first.patch";
      url = https://gitlab.gnome.org/GNOME/network-manager-applet/commit/9d79ffdb148b31c7194c66946c87b6cd57ed54a3.patch;
      sha256 = "1v0pdvkglrcfl1khp9j17cw0gvwg8scdha0wfziy054s1r6kyj23";
    })
    (fetchpatch {
       name = "0003-bluetooth-fix-an-assert-failure-on-creation-cancella.patch";
       url = https://gitlab.gnome.org/GNOME/network-manager-applet/commit/516f3f6c70ef9694d6004c64d50a9f3cd2725ab7.patch;
       sha256 = "1msk4hmri3x5chmclxm7sdj1v9jg7pxqqrarlvsmfmshdwq4ljwk";
    })
  ];

  mesonFlags = [
    "-Dselinux=false"
    "-Dappindicator=yes"
    "-Dgcr=${if withGnome then "true" else "false"}"
  ];

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs = [
    gnome3.gtk networkmanager libnotify libsecret gsettings-desktop-schemas
    polkit isocodes libgudev
    modemmanager jansson glib-networking
    libindicator-gtk3 libappindicator-gtk3
  ] ++ stdenv.lib.optionals withGnome [ gnome3.gcr webkitgtk ];

  nativeBuildInputs = [ meson ninja intltool pkgconfig wrapGAppsHook gobjectIntrospection gtk-doc docbook_xsl libxml2 ];

  propagatedUserEnvPkgs = [
    hicolor-icon-theme
  ];

  NIX_CFLAGS = [
    ''-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile-broadband-provider-info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanagerapplet";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/NetworkManager;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom rickynils ];
    platforms = platforms.linux;
  };
}
