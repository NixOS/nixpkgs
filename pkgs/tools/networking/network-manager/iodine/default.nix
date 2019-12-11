{ stdenv, fetchurl, substituteAll, iodine, intltool, pkgconfig, networkmanager, libsecret, gtk3
, withGnome ? true, gnome3, fetchpatch, networkmanagerapplet }:

let
  pname = "NetworkManager-iodine";
  version = "1.2.0";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0njdigakidji6mfmbsp8lfi8wl88z1dk8cljbva2w0xazyddbwyh";
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

  buildInputs = [ iodine networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk3 libsecret networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = [ "-DGLIB_DISABLE_DEPRECATION_WARNINGS" ];

  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-iodine";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
