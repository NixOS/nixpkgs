{ callPackage, lib, fetchurl, fetchpatch, autoreconfHook }:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{
  openssh = common rec {
    pname = "openssh";
    version = "9.6p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-kQIRwHJVqMWtZUORtA7lmABxDdgRndU2LeCThap6d3w=";
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = lib.teams.helsinki-systems.members;
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "9.5p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-8Cbnt5un+1QPdRgq+W3IqPHbOV+SK7yfbKYDZyaGCGs=";
    };

    extraPatches = let url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/700625bcd86b74cf3fb9536aeea250d7f8cd1fd5/security/openssh-portable/files/extra-patch-hpn"; in
    [
      ./ssh-keysign-8.5.patch

      # HPN Patch from FreeBSD ports
      (fetchpatch {
        name = "ssh-hpn-wo-channels.patch";
        inherit url;
        stripLen = 1;
        excludes = [ "channels.c" ];
        hash = "sha256-hYB3i0ifNOgGLYwElMJFcT+ktczLKciq3qw1tTHZHcc=";
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
    version = "9.5p1";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-8Cbnt5un+1QPdRgq+W3IqPHbOV+SK7yfbKYDZyaGCGs=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-1/debian/patches/gssapi.patch";
        sha256 = "sha256-E36jxnPcu6RTyXXb9yVBCoFIVchiOSLX7L74ng1Dmao=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
