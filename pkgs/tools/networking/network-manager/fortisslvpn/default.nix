{ stdenv, fetchurl, substituteAll, openfortivpn, intltool, pkgconfig, file, gtk3,
networkmanager, ppp, libsecret, withGnome ? true, gnome3, fetchpatch, networkmanagerapplet }:

let
  pname = "NetworkManager-fortisslvpn";
  version = "1.2.10";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sw66cxgs4in4cjp1cm95c5ijsk8xbbmq4ykg2jwqwgz6cf2lr3s";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit openfortivpn;
    })
    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/NetworkManager-fortisslvpn/merge_requests/11.patch";
      sha256 = "0l7l2r1njh62lh2pf497ibf99sgkvjsj58xr76qx3jxgq9zfw6n9";
    })
  ];

  buildInputs = [ openfortivpn networkmanager ppp ]
    ++ stdenv.lib.optionals withGnome [ gtk3 libsecret networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig file ];

  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/var"
    "--enable-absolute-paths"
  ];

  # the installer only create an empty directory in localstatedir, so
  # we can drop it
  installFlags = [ "localstatedir=." ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-fortisslvpn";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's FortiSSL plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2;
  };
}

