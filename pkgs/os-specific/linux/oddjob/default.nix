{ lib
, fetchurl
, stdenv
, autoreconfHook
, dbus
, libxml2
, pam
, pkg-config
, systemd
}:

stdenv.mkDerivation rec {
  pname = "oddjob";
  version = "0.34.7";

  src = fetchurl {
     url = "https://pagure.io/oddjob/archive/${pname}-${version}/oddjob-${pname}-${version}.tar.gz";
     hash = "sha256-SUOsMH55HtEsk5rX0CXK0apDObTj738FGOaL5xZRnIM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =[
    libxml2
    dbus
    pam
    systemd
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'SYSTEMDSYSTEMUNITDIR=`pkg-config --variable=systemdsystemunitdir systemd 2> /dev/null`' "SYSTEMDSYSTEMUNITDIR=${placeholder "out"}" \
      --replace 'SYSTEMDSYSTEMUNITDIR=`pkg-config --variable=systemdsystemunitdir systemd`' "SYSTEMDSYSTEMUNITDIR=${placeholder "out"}"
  '';

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-selinux-acls=no"
    "--with-selinux-labels=no"
    "--disable-systemd"
  ];

  postConfigure = ''
    substituteInPlace src/oddjobd.c \
      --replace "globals.selinux_enabled" "FALSE"
  '';

  meta = with lib; {
    description = "Odd Job Daemon";
    homepage = "https://pagure.io/oddjob";
    changelog = "https://pagure.io/oddjob/blob/oddjob-${version}/f/ChangeLog";
    license = licenses.bsd0;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SohamG ];
  };
}
