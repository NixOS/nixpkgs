{ lib, stdenv, fetchurl, bash, coreutils, python3
, libcap_ng, policycoreutils, selinux-python, dbus
, xorgserver, openbox, xmodmap }:

# this is python3 only as it depends on selinux-python

with lib;
with python3.pkgs;

stdenv.mkDerivation rec {
  pname = "selinux-sandbox";
  version = "3.3";
  inherit (policycoreutils) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/selinux-sandbox-${version}.tar.gz";
    sha256 = "0rw8pxfqhl6ww4w31fbf4hi3zilh1n3b1rfjm7ra76mm78wfyylj";
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
    license = licenses.gpl2Only;
    homepage = "https://selinuxproject.org";
    platforms = platforms.linux;
  };
}
