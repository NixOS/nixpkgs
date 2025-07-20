{
  callPackage,
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
}:
let
  common = opts: callPackage (import ./common.nix opts) { };

  # Gets the correct OpenSSH URL for a given version.
  urlFor =
    version:
    let
      urlVersion =
        {
          # 10.0p1 was accidentally released as 10.0p2:
          # https://www.openwall.com/lists/oss-security/2025/04/09/6
          "10.0p2" = "10.0p1";
        }
        .${version} or version;
    in
    "mirror://openbsd/OpenSSH/portable/openssh-${urlVersion}.tar.gz";
in
{
  openssh = common rec {
    pname = "openssh";
    version = "10.0p2";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-AhoucJoO30JQsSVr1anlAEEakN3avqgw7VnO+Q652Fw=";
    };

    extraPatches = [
      # Use ssh-keysign from PATH
      # ssh-keysign is used for host-based authentication, and is designed to be used
      # as SUID-root program. OpenSSH defaults to referencing it from libexec, which
      # cannot be made SUID in Nix.
      ./ssh-keysign-8.5.patch
    ];
    extraMeta = {
      maintainers = with lib.maintainers; [
        philiptaron
        numinit
      ];
      teams = [ lib.teams.helsinki-systems ];
    };
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "10.0p2";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = urlFor version;
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
    version = "10.0p2";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-AhoucJoO30JQsSVr1anlAEEakN3avqgw7VnO+Q652Fw=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%2510.0p1-1/debian/patches/gssapi.patch";
        hash = "sha256-7Q27tvtCY3b9evC3lbqEz4u7v5DcerjWZfhh8azIAQo=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
