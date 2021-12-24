{ lib, stdenv, fetchurl, fetchFromGitHub, python, buildPythonApplication
, libselinux
# Propagated to blivet
, useNixUdev ? true
# Needed by NixOps
, udevSoMajor ? null
# Propagated dependencies
, pkgs, urlgrabber
}:

let
  blivet = import ./blivet.nix {
    inherit lib fetchurl buildPythonApplication;
    inherit pykickstart pyparted pyblock cryptsetup libselinux multipath_tools;
    inherit useNixUdev;
    inherit (pkgs) lsof util-linux systemd;
  };

  cryptsetup = import ./cryptsetup.nix {
    inherit lib stdenv fetchurl python;
    inherit (pkgs) fetchpatch pkg-config libgcrypt libuuid popt lvm2;
  };

  dmraid = import ./dmraid.nix {
    inherit lib stdenv fetchurl lvm2;
  };

  lvm2 = import ./lvm2.nix {
    inherit lib stdenv fetchurl;
    inherit (pkgs) fetchpatch pkg-config util-linux systemd coreutils;
  };

  multipath_tools = import ./multipath-tools.nix {
    inherit lib stdenv fetchurl lvm2;
    inherit (pkgs) fetchpatch readline systemd libaio gzip;
  };

  parted = import ./parted.nix {
    inherit lib stdenv fetchurl;
    inherit (pkgs) fetchpatch util-linux readline libuuid gettext check lvm2;
  };

  pyblock = import ./pyblock.nix {
    inherit lib stdenv fetchurl python lvm2 dmraid;
  };

  pykickstart = import ./pykickstart.nix {
    inherit lib fetchurl python buildPythonApplication urlgrabber;
  };

  pyparted = import ./pyparted.nix {
    inherit lib stdenv fetchurl python buildPythonApplication parted;
    inherit (pkgs) pkg-config e2fsprogs;
  };

in buildPythonApplication rec {
  pname = "nixpart";
  version = "0.4.1";
  disabled = python.isPy3k;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpart";
    rev = "v${version}";
    sha256 = "sha256-edl3mRg9Bn9Bd6FJl4zf1WS7XRcHTL5ey9LuKhaZG7I=";
  };

  propagatedBuildInputs = [ blivet ];

  doCheck = false;

  meta = with lib; {
    description = "NixOS storage manager/partitioner";
    homepage = "https://github.com/NixOS/nixpart";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aszlig ];
    platforms = platforms.linux;
  };
}
