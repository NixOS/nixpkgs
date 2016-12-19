{ stdenv, fetchurl, python, buildPythonApplication
# Propagated to blivet
, useNixUdev ? true
# No longer needed, but kept for backwards-compatibility with older NixOps.
, udevSoMajor ? null
# Propagated dependencies
, pkgs, urlgrabber
}:

let
  blivet = import ./blivet.nix {
    inherit stdenv fetchurl buildPythonApplication;
    inherit pykickstart pyparted pyblock cryptsetup multipath_tools;
    inherit useNixUdev;
    inherit (pkgs) lsof utillinux systemd;
    libselinux = pkgs.libselinux.override { enablePython = true; };
  };

  cryptsetup = import ./cryptsetup.nix {
    inherit stdenv fetchurl python;
    inherit (pkgs) pkgconfig libgcrypt libuuid popt;
    devicemapper = lvm2;
  };

  dmraid = import ./dmraid.nix {
    inherit stdenv fetchurl;
    devicemapper = lvm2;
  };

  lvm2 = import ./lvm2.nix {
    inherit stdenv fetchurl;
    inherit (pkgs) pkgconfig utillinux systemd coreutils;
  };

  multipath_tools = import ./multipath-tools.nix {
    inherit stdenv fetchurl lvm2;
    inherit (pkgs) readline systemd libaio gzip;
  };

  parted = import ./parted.nix {
    inherit stdenv fetchurl;
    inherit (pkgs) utillinux readline libuuid gettext check;
    devicemapper = lvm2;
  };

  pyblock = import ./pyblock.nix {
    inherit stdenv fetchurl python lvm2 dmraid;
  };

  pykickstart = import ./pykickstart.nix {
    inherit stdenv fetchurl python buildPythonApplication urlgrabber;
  };

  pyparted = import ./pyparted.nix {
    inherit stdenv fetchurl python buildPythonApplication parted;
    inherit (pkgs) pkgconfig e2fsprogs;
  };

in buildPythonApplication rec {
  name = "nixpart-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/aszlig/nixpart/archive/v${version}.tar.gz";
    sha256 = "0avwd8p47xy9cydlbjxk8pj8q75zyl68gw2w6fnkk78dcb1a3swp";
  };

  propagatedBuildInputs = [ blivet ];

  doCheck = false;

  meta = {
    description = "NixOS storage manager/partitioner";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
    platforms = stdenv.lib.platforms.linux;
  };
}
