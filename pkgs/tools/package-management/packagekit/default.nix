{ stdenv, fetchFromGitHub, lib
, intltool, glib, pkgconfig, polkit, python3, sqlite
, gobject-introspection, vala, gtk-doc, autoreconfHook, autoconf-archive
# TODO: set enableNixBackend to true, as soon as it builds
, nix, enableNixBackend ? false, boost
, enableCommandNotFound ? false
, enableBashCompletion ? false, bash-completion ? null
, enableSystemd ? stdenv.isLinux, systemd }:

stdenv.mkDerivation rec {
  pname = "packagekit";
  version = "1.1.13";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "PackageKit";
    rev = "PACKAGEKIT_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "0xmgac27p5z8wr56yw3cqhywnlvaf8kvyv1g0nzxnq167xj5vxam";
  };

  buildInputs = [ glib polkit python3 gobject-introspection ]
                  ++ lib.optional enableSystemd systemd
                  ++ lib.optional enableBashCompletion bash-completion;
  propagatedBuildInputs = [ sqlite nix boost ];
  nativeBuildInputs = [ vala intltool pkgconfig autoreconfHook autoconf-archive gtk-doc ];

  preAutoreconf = ''
    gtkdocize
    intltoolize
  '';

  configureFlags = [
    (if enableSystemd then "--enable-systemd" else "--disable-systemd")
    "--disable-dummy"
    "--disable-cron"
    "--enable-introspection"
    "--disable-offline-update"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-dbus-sys=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ]
  ++ lib.optional enableNixBackend "--enable-nix"
  ++ lib.optional (!enableBashCompletion) "--disable-bash-completion"
  ++ lib.optional (!enableCommandNotFound) "--disable-command-not-found";

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with lib; {
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
