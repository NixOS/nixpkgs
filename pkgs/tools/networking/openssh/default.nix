{ callPackage, lib, fetchurl, fetchpatch, autoreconfHook }:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{
  openssh = common rec {
    pname = "openssh";
    version = "9.7p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-SQQm92bYKidj/KzY2D6j1weYdQx70q/y5X3FZg93P/0=";
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = lib.teams.helsinki-systems.members;
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "9.7p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-SQQm92bYKidj/KzY2D6j1weYdQx70q/y5X3FZg93P/0=";
    };

    extraPatches = let url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/b3f86656fc67aa397f60747c85f7f7b967c3279d/security/openssh-portable/files/extra-patch-hpn"; in
    [
      ./ssh-keysign-8.5.patch

      # HPN Patch from FreeBSD ports
      (fetchpatch {
        name = "ssh-hpn-wo-channels.patch";
        inherit url;
        stripLen = 1;
        excludes = [ "channels.c" ];
        hash = "sha256-MydulQvz8sDVQ6Up9U1yrsiyI5EGmyKl/stUk7DvVOU=";
      })

      (fetchpatch {
        name = "ssh-hpn-channels.patch";
        inherit url;
        extraPrefix = "";
        includes = [ "channels.c" ];
        hash = "sha256-pDLUbjv5XIyByEbiRAXC3WMUPKmn15af1stVmcvr7fE=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];

    extraConfigureFlags = [ "--with-hpn" ];
    extraMeta = {
      maintainers = with lib.maintainers; [ abbe ];
    };
  };

  openssh_gssapi = common rec {
    pname = "openssh-with-gssapi";
    version = "9.7p1";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-SQQm92bYKidj/KzY2D6j1weYdQx70q/y5X3FZg93P/0=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-3/debian/patches/gssapi.patch";
        hash = "sha256-/lEbH5sIS+o+DStEDAghFy43nZlvcIXSFJrnvp+fDdY=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
