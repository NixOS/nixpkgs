{
  callPackage,
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
}:
let
  common = opts: callPackage (import ./common.nix opts) { };

  # Gets the OpenSSH mirror URL.
  urlFor = version: "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
in
{
  openssh = common rec {
    pname = "openssh";
    version = "10.5p1";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-1E0oqDnqna+WnMaRUP3lmRCys5Nh2tgaO9bL0ZIY2xE=";
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
        das_j
        helsinki-Jo
        numinit
        philiptaron
      ];
    };
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "10.5p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-1E0oqDnqna+WnMaRUP3lmRCys5Nh2tgaO9bL0ZIY2xE=";
    };

    extraPatches =
      let
        urlBase = "https://raw.githubusercontent.com/freebsd/freebsd-ports/b6e1767f0a502a384a7b9270a89123775a4bdc21/security/openssh-portable/files";
        noBlocklistdHpnGluePatch = "${urlBase}/extra-patch-no-blocklistd-hpn-glue";
        hpnPatch = "${urlBase}/extra-patch-hpn";
      in
      [
        ./ssh-keysign-8.5.patch

        # the blocklistd patch from FreeBSD ports is now required for HPN,
        # unless we apply this HPN glue patch
        (fetchpatch {
          name = "ssh-no-blocklistd-hpn-glue.patch";
          url = noBlocklistdHpnGluePatch;
          extraPrefix = "";
          hash = "sha256-+AeJ9fLmmT/P07JZvGaXpNft+2F9PoFsbzr+s9wfdro=";
        })

        # HPN Patch from FreeBSD ports
        (fetchpatch {
          name = "ssh-hpn-wo-channels.patch";
          url = hpnPatch;
          stripLen = 1;
          excludes = [ "channels.c" ];
          hash = "sha256-Hq30DZ5i32aHalliyjdELe91aMDTT7/vAANY8RVn6B4=";
        })

        (fetchpatch {
          name = "ssh-hpn-channels.patch";
          url = hpnPatch;
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
    version = "10.4p1";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-72Am3SrqjVYFljjV0yYpAsiSzrqfiDlYNeDQbT+2Mjg=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "servconf-fix-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%2510.4p1-1/debian/patches/servconf-fix-gssapi.patch";
        hash = "sha256-ypyaoEhwxo7SYVpjMkCQnrcFgY2ouWJQlrbJy50Lidk=";
      })

      (fetchpatch {
        name = "gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%2510.4p1-1/debian/patches/gssapi.patch";
        hash = "sha256-K12AE4C0zMdRdMsRMQCMRIFvN+NhNvCgyt0NDZp7n24=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
