{ callPackage, lib, fetchurl, fetchpatch, fetchFromGitHub, autoreconfHook }:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{

  openssh = common rec {
    pname = "openssh";
    version = "9.3p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-6bq6dwGnalHz2Fpiw4OjydzZf6kAuFm8fbEUwYaK+Kg=";
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = with lib.maintainers; [ das_j ];
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "9.3p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-6bq6dwGnalHz2Fpiw4OjydzZf6kAuFm8fbEUwYaK+Kg=";
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
    version = "9.0p1";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      sha256 = "12m2f9czvgmi7akp7xah6y7mrrpi280a3ksk47iwr7hy2q1475q3";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-1/debian/patches/gssapi.patch";
        sha256 = "sha256-VG7+2dfu09nvHWuSAB6sLGMmjRCDCysl/9FR1WSF21k=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
    extraMeta.knownVulnerabilities = [ "CVE-2023-28531" ];
  };
}
