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
    version = "10.3p1";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-VmgqNruS3PS08Bb9jsjnQFm3mo3iXBXWcNcx59GORfQ=";
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
    version = "10.3p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-VmgqNruS3PS08Bb9jsjnQFm3mo3iXBXWcNcx59GORfQ=";
    };

    extraPatches =
      let
        urlBase = "https://raw.githubusercontent.com/freebsd/freebsd-ports/294be7ad9ef5106b696d830e06b9f322bd79d6f5/security/openssh-portable/files";
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
          hash = "sha256-dEYCSBcUXbSBzoMV/6QwLl5tj0c0/DPTtArchfRRQvM=";
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
    version = "10.2p1";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-zMQsBBmTeVkmP6Hb0W2vwYxWuYTANWLSk3zlamD3mLI=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%2510.2p1-6/debian/patches/gssapi.patch";
        hash = "sha256-mYrJJrE6l0r/VYLWlOTGkKLzj9Dj4wOLgJyW/NLGaeo=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
