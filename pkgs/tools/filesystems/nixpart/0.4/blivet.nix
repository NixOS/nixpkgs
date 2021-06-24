# FIXME: Unify with pkgs/development/python-modules/blivet/default.nix.

{ lib, fetchurl, buildPythonApplication, pykickstart, pyparted, pyblock
, libselinux, cryptsetup, multipath_tools, lsof, util-linux
, useNixUdev ? true, systemd ? null
# useNixUdev is here for bw compatibility
}:

assert useNixUdev -> systemd != null;

buildPythonApplication rec {
  pname = "blivet";
  version = "0.17-1";

  src = fetchurl {
    url = "https://git.fedorahosted.org/cgit/blivet.git/snapshot/"
        + "${pname}-${version}.tar.bz2";
    sha256 = "1k3mws2q0ryb7422mml6idmaasz2i2v6ngyvg6d976dx090qnmci";
  };

  patches = [ ./blivet.patch ];

  postPatch = ''
    sed -i -e 's|"multipath"|"${multipath_tools}/sbin/multipath"|' \
      blivet/devicelibs/mpath.py blivet/devices.py
    sed -i -e '/"wipefs"/ {
      s|wipefs|${util-linux.bin}/sbin/wipefs|
      s/-f/--force/
    }' blivet/formats/__init__.py
    sed -i -e 's|"lsof"|"${lsof}/bin/lsof"|' blivet/formats/fs.py
    sed -i -r -e 's|"(u?mount)"|"${util-linux.bin}/bin/\1"|' blivet/util.py
    sed -i -e '/find_library/,/find_library/ {
      c libudev = "${lib.getLib systemd}/lib/libudev.so.1"
    }' blivet/pyudev.py
  '';

  propagatedBuildInputs = [
    pykickstart pyparted pyblock libselinux cryptsetup
  ] ++ lib.optional useNixUdev systemd;

  # tests are currently _heavily_ broken upstream
  doCheck = false;

  meta = with lib; {
    homepage = "https://fedoraproject.org/wiki/Blivet";
    description = "Module for management of a system's storage configuration";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
  };
}
