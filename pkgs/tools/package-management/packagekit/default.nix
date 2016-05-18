{ stdenv, fetchurl, intltool, glib, pkgconfig, polkit, python, sqlite }:

stdenv.mkDerivation rec {
  name = "packagekit-${version}";
  version = "1.1.1";

  src = fetchurl {
    sha256 = "1i6an483vmm6y39szr2alq5vf6kfxhk3j5ca79qrshcj9jjlhcs8";
    url = "http://www.freedesktop.org/software/PackageKit/releases/PackageKit-${version}.tar.xz";
  };

  buildInputs = [ glib polkit python ];
  propagatedBuildInputs = [ sqlite ];
  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "--disable-static"
    "--disable-python3"
    "--disable-networkmanager"
    "--disable-connman"
    "--disable-systemd"
    "--disable-bash-completion"
    "--disable-gstreamer-plugin"
    "--disable-gtk-module"
    "--disable-command-not-found"
    "--disable-cron"
    "--disable-daemon-tests"
    "--disable-alpm"
    "--disable-aptcc"
    "--enable-dummy"
    "--disable-entropy"
    "--disable-hif"
    "--disable-pisi"
    "--disable-poldek"
    "--disable-portage"
    "--disable-ports"
    "--disable-katja"
    "--disable-urpmi"
    "--disable-yum"
    "--disable-zypp"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    # Don't install anything to e.g. $out/var/cache:
    for dir in src data; do
      substituteInPlace $dir/Makefile \
        --replace " install-data-hook" "" \
        --replace " install-databaseDATA" ""
    done
  '';

  meta = with stdenv.lib; {
    description = "System to facilitate installing and updating packages";
    longDescription = ''
      PackageKit is a system designed to make installing and updating software
      on your computer easier. The primary design goal is to unify all the
      software graphical tools used in different distributions, and use some of
      the latest technology like PolicyKit. The actual nuts-and-bolts distro
      tool (dnf, apt, etc) is used by PackageKit using compiled and scripted
      helpers. PackageKit isn't meant to replace these tools, instead providing
      a common set of abstractions that can be used by standard GUI and text
      mode package managers.
    '';
    homepage = http://www.packagekit.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
