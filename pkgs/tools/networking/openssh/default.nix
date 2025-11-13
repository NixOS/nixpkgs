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
    version = "10.2p1";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-zMQsBBmTeVkmP6Hb0W2vwYxWuYTANWLSk3zlamD3mLI=";
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
    version = "10.2p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = urlFor version;
      hash = "sha256-zMQsBBmTeVkmP6Hb0W2vwYxWuYTANWLSk3zlamD3mLI=";
    };

    extraPatches =
      let
        url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/7d4f03d56d19a19a15399a03b3ceca8a0f5924b4/security/openssh-portable/files/extra-patch-hpn";
      in
      [
        ./ssh-keysign-8.5.patch

        # HPN Patch from FreeBSD ports
        (fetchpatch {
          name = "ssh-hpn-wo-channels.patch";
          inherit url;
          stripLen = 1;
          excludes = [ "channels.c" ];
          hash = "sha256-BGR0Jn1JoD/0q9/TKjygg9C3UWeVf0R2DrH0esMzmpY=";
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
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%2510.1p1-1/debian/patches/gssapi.patch";
        hash = "sha256-/wJ3AA+RscHjFRSeL0LENviKlCglpOi7HNuCxidpQV8=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
