{ callPackage, lib, fetchurl, fetchpatch, fetchFromGitHub, autoreconfHook }:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{

  openssh = common rec {
    pname = "openssh";
    version = "9.1p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-GfhQCcfj4jeH8CNvuxV4OSq01L+fjsX+a8HNfov90og=";
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = with lib.maintainers; [ das_j ];
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "9.1p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-GfhQCcfj4jeH8CNvuxV4OSq01L+fjsX+a8HNfov90og=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      # HPN Patch from FreeBSD ports
      (fetchpatch {
        name = "ssh-hpn.patch";
        url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/ae66cffc19f357cbd51d5841c9b110a9ffd63e32/security/openssh-portable/files/extra-patch-hpn";
        stripLen = 1;
        sha256 = "sha256-p3CmMqTgrqFZUo4ZuqaPLczAhjmPufkCvptVW5dI+MI=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];

    extraConfigureFlags = [ "--with-hpn" ];
    extraMeta.maintainers = with lib.maintainers; [ abbe ];
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
  };
}
