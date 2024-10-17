{ stdenv
, fetchFromGitLab
, openldap
, libkrb5
, packagekit
, polkit
, libxslt
, intltool
, glib
, pkg-config
, systemd
, autoreconfHook
, samba
, adcli
, oddjob
, sssd
, bash
}:

stdenv.mkDerivation rec {

  pname = "realmd";
  version = "0.17.0";

  srcs = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1c6q2a86kk2f1akzc36nh52hfwsmmc0mbp6ayyjxj4zsyk9zx5bf";
  };

  # I dont know how to include this as a shell script.
  preConfigure = ''
    substituteInPlace service/realmd-defaults.conf \
    --replace "/usr/sbin/winbindd" "${samba}/sbin/winbindd"
    substituteInPlace service/realmd-defaults.conf \
    --replace "/usr/bin/net" "${samba}/sbin/net"
    substituteInPlace service/realmd-defaults.conf \
    --replace "/usr/sbin/adcli" "${adcli}/bin/adcli"
    substituteInPlace service/realmd-defaults.conf \
    --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/sbin/winbindd" "${samba}/sbin/winbindd"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/bin/wbinfo" "${samba}/bin/wbinfo"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/bin/net" "${samba}/sbin/net"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/sbin/authconfig" "${samba}/sbin/authconfig"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/sbin/adcli" "${adcli}/bin/adcli"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/sbin/oddjobd" "${oddjob}/sbin/oddjobd"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/libexec/oddjob/mkhomedir" "${oddjob}/libexec/oddjob/mkhomedir"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/sbin/sssd" "${sssd}/sbin/sssd"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/sbin/sss_cache" "${sssd}/sbin/sss_cache"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/bin/sh" "${bash}/bin/bash"
    substituteInPlace service/realmd-redhat.conf \
    --replace "/usr/bin/systemctl" "${systemd}/bin/systemctl"

    cp service/realmd-redhat.conf service/realmd-nixos.conf
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config];
  buildInputs =
    [ openldap libkrb5 polkit libxslt intltool glib systemd];

  configureFlags = [
    "--with-distro=nixos"
    "--disable-doc"
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-systemd-unit-dir=${placeholder "out"}/share/systemd"
  ];
}
