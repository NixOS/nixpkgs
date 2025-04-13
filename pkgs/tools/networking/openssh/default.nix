{
  callPackage,
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
}:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{
  openssh = common rec {
    pname = "openssh";
    version = "10.0p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-AhoucJoO30JQsSVr1anlAEEakN3avqgw7VnO+Q652Fw=";
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = lib.teams.helsinki-systems.members ++ [ lib.maintainers.philiptaron ];
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "10.0p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-AhoucJoO30JQsSVr1anlAEEakN3avqgw7VnO+Q652Fw=";
    };

    extraPatches =
      let
        url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/dde9561b3ff73639aeebe8ec33ad52ecca0bf58d/security/openssh-portable/files/extra-patch-hpn";
      in
      [
        ./ssh-keysign-8.5.patch

        # HPN Patch from FreeBSD ports
        (fetchpatch {
          name = "ssh-hpn-wo-channels.patch";
          inherit url;
          stripLen = 1;
          excludes = [ "channels.c" ];
          hash = "sha256-0HQAacNdvqX+7CTDhkbgAyb0WbqnnH6iAYQBFh8XenA=";
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
    version = "9.9p2";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-karbYD4IzChe3fll4RmdAlhfqU2ZTWyuW0Hhch4hVnM=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-1/debian/patches/gssapi.patch";
        hash = "sha256-JyOXA8Al8IFLdndJQ1LO+r4hJqtXjz1NHwOPiSAQkE8=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
