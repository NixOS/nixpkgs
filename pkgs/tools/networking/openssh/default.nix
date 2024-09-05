{ callPackage, lib, fetchurl, fetchpatch, autoreconfHook }:
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{
  openssh = common rec {
    pname = "openssh";
    version = "9.8p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-3YvQAqN5tdSZ37BQ3R+pr4Ap6ARh9LtsUjxJlz9aOfM=";
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = lib.teams.helsinki-systems.members;
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
    version = "9.8p1";
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-3YvQAqN5tdSZ37BQ3R+pr4Ap6ARh9LtsUjxJlz9aOfM=";
    };

    extraPatches = let url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/7ba88c964b6e5724eec462021d984da3989e6a08/security/openssh-portable/files/extra-patch-hpn"; in
    [
      ./ssh-keysign-8.5.patch

      # HPN Patch from FreeBSD ports
      (fetchpatch {
        name = "ssh-hpn-wo-channels.patch";
        inherit url;
        stripLen = 1;
        excludes = [ "channels.c" ];
        hash = "sha256-zk7t6FNzTE+8aDU4QuteR1x0W3O2gjIQmeCkTNbaUfA=";
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
    version = "9.8p1";
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-3YvQAqN5tdSZ37BQ3R+pr4Ap6ARh9LtsUjxJlz9aOfM=";
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-3/debian/patches/gssapi.patch";
        hash = "sha256-BnmEZ5pMIbbysesMSm54ykdweH4JudM9D4Pn5uWf3EY=";
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
  };
}
