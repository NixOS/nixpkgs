{ callPackage, lib, fetchurl, fetchpatch, fetchFromGitHub, autoreconfHook }:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{

  openssh = common rec {
    pname = "openssh";
    version = "8.8p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      sha256 = "1s8z6f7mi1pwsl79cqai8cr350m5lf2ifcxff57wx6mvm478k425";
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = with lib.maintainers; [ das_j ];
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "8.9p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      sha256 = "1ry5prcax0134v6srkgznpl9ch5snkgq7yvjqvd8c5mbnxa7cjgx";
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
    version = "8.4p1";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      sha256 = "091b3pxdlj47scxx6kkf4agkx8c8sdacdxx8m1dw1cby80pd40as";
    };

    extraPatches = [
      ./ssh-keysign-8.4.patch

      # See https://github.com/openssh/openssh-portable/pull/206
      ./ssh-copy-id-fix-eof.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-2/debian/patches/gssapi.patch";
        sha256 = "1z1ckzimlkm1dmr9f5fqjnjg28gsqcwx6xka0klak857548d2lp2";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];

    extraMeta.knownVulnerabilities = [
      "CVE-2021-28041"
      "CVE-2021-41617"
    ];
  };
}
