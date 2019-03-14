{ stdenv, fetchFromGitHub, lib
, intltool, glib, pkgconfig, polkit, python, sqlite
, gobject-introspection, vala, gtk-doc, autoreconfHook, autoconf-archive
# TODO: set enableNixBackend to true, as soon as it builds
, nix, enableNixBackend ? false, boost
, enableCommandNotFound ? false
, enableBashCompletion ? false, bash-completion ? null
, enableSystemd ? stdenv.isLinux, systemd }:

stdenv.mkDerivation rec {
  name = "packagekit-${version}";
  version = "1.1.12";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "PackageKit";
    rev = "PACKAGEKIT_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "02wq3jw3mkdld90irh5vdfd5bri2g1p89mhrmj56kvif1fqak46x";
  };

  buildInputs = [ glib polkit python gobject-introspection vala ]
                  ++ lib.optional enableSystemd systemd
                  ++ lib.optional enableBashCompletion bash-completion;
  propagatedBuildInputs = [ sqlite nix boost ];
  nativeBuildInputs = [ intltool pkgconfig autoreconfHook autoconf-archive gtk-doc ];

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
    "--with-dbus-sys=$(out)/etc/dbus-1/system.d"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system/"
  ]
  ++ lib.optional enableNixBackend "--enable-nix"
  ++ lib.optional (!enableBashCompletion) "--disable-bash-completion"
  ++ lib.optional (!enableCommandNotFound) "--disable-command-not-found";

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=\${out}/etc"
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
