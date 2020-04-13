{ stdenv, fetchurl, bash, coreutils, python3
, libcap_ng, policycoreutils, selinux-python, dbus
, xorgserver, openbox, xmodmap }:

# this is python3 only as it depends on selinux-python

with stdenv.lib; 
with python3.pkgs;

stdenv.mkDerivation rec {
  pname = "selinux-sandbox";
  version = "2.9";
  inherit (policycoreutils) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/selinux-sandbox-${version}.tar.gz";
    sha256 = "0qj20jyi8v1653xdqj5yak3wwbvg5bw8f2jmx8fpahl6y1bmz481";
  };

  nativeBuildInputs = [ wrapPython ];
  buildInputs = [ bash coreutils libcap_ng policycoreutils python3 xorgserver openbox xmodmap dbus ];
  propagatedBuildInputs = [ pygobject3 selinux-python ];

  postPatch = ''
    # Fix setuid install
    substituteInPlace Makefile --replace "-m 4755" "-m 755"
    substituteInPlace sandboxX.sh \
      --replace "#!/bin/sh" "#!${bash}/bin/sh" \
      --replace "/usr/share/sandbox/start" "${placeholder "out"}/share/sandbox/start" \
      --replace "/usr/bin/cut" "${coreutils}/bin/cut" \
      --replace "/usr/bin/Xephyr" "${xorgserver}/bin/Xepyhr" \
      --replace "secon" "${policycoreutils}/bin/secon"
    substituteInPlace sandbox \
      --replace "/usr/sbin/seunshare" "$out/bin/seunshare" \
      --replace "/usr/share/sandbox" "$out/share/sandbox" \
      --replace "/usr/share/locale" "${policycoreutils}/share/locale" \
      --replace "/usr/bin/openbox" "${openbox}/bin/openbox" \
      --replace "#!/bin/sh" "#!${bash}/bin/sh" \
      --replace "dbus-" "${dbus}/bin/dbus-" \
      --replace "/usr/bin/xmodmap" "${xmodmap}/bin/xmodmap" \
      --replace "/usr/bin/shred" "${coreutils}/bin/shred" \
      --replace "/usr/bin/test" "${coreutils}/bin/test" \
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc/sysconfig"
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "SELinux sandbox utility";
    license = licenses.gpl2;
    homepage = "https://selinuxproject.org";
    platforms = platforms.linux;
  };
}

