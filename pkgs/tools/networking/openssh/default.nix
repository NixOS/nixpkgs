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
    version = "10.6p2";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-muRIcgkM8vBrPPn/FH5/FvMJZxNAdj7S+ZJIOYrinVs=";
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
    version = "10.6p2";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-muRIcgkM8vBrPPn/FH5/FvMJZxNAdj7S+ZJIOYrinVs=";
    };

    extraPatches =
      let
        urlBase = "https://raw.githubusercontent.com/freebsd/freebsd-ports/b8d0a9401efe21977c43c0f60cf534042a070f56/security/openssh-portable/files";
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
          hash = "sha256-QiPBQrcAQfFaFoTxY+mHoRO39+WTN1xTObEfE0i4mBM=";
        })

        # HPN Patch from FreeBSD ports
        (fetchpatch {
          name = "ssh-hpn-wo-channels.patch";
          url = hpnPatch;
          stripLen = 1;
          excludes = [ "channels.c" ];
          hash = "sha256-ZUDAELNCm71+/EzOwoGjvy6tt/HuIuum3DwfPL7ALsQ=";
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
    version = "10.6p2";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-muRIcgkM8vBrPPn/FH5/FvMJZxNAdj7S+ZJIOYrinVs=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh-gssapi/raw/debian/1%2510.6p1-1/debian/patches/gssapi.patch";
        hash = "sha256-/gxGxXHyXo4xJXdoZiGSvKfej3Uws1vuzZUZXgZ2UwY=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
