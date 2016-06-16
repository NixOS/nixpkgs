{ stdenv, fetchFromGitHub, intltool, glib, pkgconfig, polkit, python, sqlite, systemd
, gobjectIntrospection, vala, gtk_doc, autoreconfHook, autoconf-archive
, nix, boost
, enableCommandNotFound ? false
, enableBashCompletion ? false, bashCompletion ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "packagekit-2016-06-03";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "PackageKit";
    rev = "99fd83bbb26badf43c6a17a9f0c6dc054c7484c8";
    sha256 = "0y42vl6r1wh57sbjfkn4khjs78q54wshf4p0v4nly9s7hydxpi6a";
  };

  buildInputs = [ glib polkit systemd python gobjectIntrospection vala ]
                  ++ optional enableBashCompletion bashCompletion;
  propagatedBuildInputs = [ sqlite nix boost ];
  nativeBuildInputs = [ intltool pkgconfig autoreconfHook autoconf-archive gtk_doc ];

  preAutoreconf = ''
    gtkdocize
    intltoolize
  '';

  configureFlags = [
    "--enable-systemd"
    "--enable-nix"
    "--disable-dummy"
    "--disable-cron"
    "--disable-introspection"
    "--disable-offline-update"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-dbus-sys=$(out)/etc/dbus-1/system.d"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system/"
  ]
  ++ optional (!enableBashCompletion) "--disable-bash-completion"
  ++ optional (!enableCommandNotFound) "--disable-command-not-found";

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
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
    maintainers = with maintainers; [ nckx matthewbauer ];
  };
}
