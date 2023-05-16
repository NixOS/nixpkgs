<<<<<<< HEAD
{ callPackage, lib, fetchurl, fetchpatch, autoreconfHook }:
=======
{ callPackage, lib, fetchurl, fetchpatch, fetchFromGitHub, autoreconfHook }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  common = opts: callPackage (import ./common.nix opts) { };
in
{
<<<<<<< HEAD
  openssh = common rec {
    pname = "openssh";
    version = "9.4p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-Ngj9kIjbIWPOs+YAyFq3nQ3j0iHlkZLqGSPiMmOGaoU=";
=======

  openssh = common rec {
    pname = "openssh";
    version = "9.3p1";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
      hash = "sha256-6bq6dwGnalHz2Fpiw4OjydzZf6kAuFm8fbEUwYaK+Kg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    extraPatches = [ ./ssh-keysign-8.5.patch ];
    extraMeta.maintainers = with lib.maintainers; [ das_j ];
  };

  openssh_hpn = common rec {
    pname = "openssh-with-hpn";
<<<<<<< HEAD
    version = "9.4p1";
=======
    version = "9.2p1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extraDesc = " with high performance networking patches";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
<<<<<<< HEAD
      hash = "sha256-Ngj9kIjbIWPOs+YAyFq3nQ3j0iHlkZLqGSPiMmOGaoU=";
    };

    extraPatches = let url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/700625bcd86b74cf3fb9536aeea250d7f8cd1fd5/security/openssh-portable/files/extra-patch-hpn"; in
    [
=======
      hash = "sha256-P2bb8WVftF9Q4cVtpiqwEhjCKIB7ITONY068351xz0Y=";
    };

    extraPatches = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      ./ssh-keysign-8.5.patch

      # HPN Patch from FreeBSD ports
      (fetchpatch {
        name = "ssh-hpn-wo-channels.patch";
<<<<<<< HEAD
        inherit url;
        stripLen = 1;
        excludes = [ "channels.c" ];
        hash = "sha256-hYB3i0ifNOgGLYwElMJFcT+ktczLKciq3qw1tTHZHcc=";
=======
        url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/10491773d88012fe81d9c039cbbba647bde9ebc9/security/openssh-portable/files/extra-patch-hpn";
        stripLen = 1;
        excludes = [ "channels.c" ];
        sha256 = "sha256-kSj0oE7gNHfIciy0/ErhdfrbmfjQmd8hduyiRXFnVZA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })

      (fetchpatch {
        name = "ssh-hpn-channels.patch";
<<<<<<< HEAD
        inherit url;
        extraPrefix = "";
        includes = [ "channels.c" ];
        hash = "sha256-pDLUbjv5XIyByEbiRAXC3WMUPKmn15af1stVmcvr7fE=";
=======
        url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/10491773d88012fe81d9c039cbbba647bde9ebc9/security/openssh-portable/files/extra-patch-hpn";
        extraPrefix = "";
        includes = [ "channels.c" ];
        sha256 = "sha256-pDLUbjv5XIyByEbiRAXC3WMUPKmn15af1stVmcvr7fE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];

    extraConfigureFlags = [ "--with-hpn" ];
    extraMeta = {
      maintainers = with lib.maintainers; [ abbe ];
<<<<<<< HEAD
=======
      knownVulnerabilities = [ "CVE-2023-28531" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  openssh_gssapi = common rec {
    pname = "openssh-with-gssapi";
<<<<<<< HEAD
    version = "9.4p1";
=======
    version = "9.0p1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extraDesc = " with GSSAPI support";

    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/openssh-${version}.tar.gz";
<<<<<<< HEAD
      sha256 = "sha256-Ngj9kIjbIWPOs+YAyFq3nQ3j0iHlkZLqGSPiMmOGaoU=";
=======
      sha256 = "12m2f9czvgmi7akp7xah6y7mrrpi280a3ksk47iwr7hy2q1475q3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    extraPatches = [
      ./ssh-keysign-8.5.patch

      (fetchpatch {
        name = "openssh-gssapi.patch";
        url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-1/debian/patches/gssapi.patch";
<<<<<<< HEAD
        sha256 = "sha256-E36jxnPcu6RTyXXb9yVBCoFIVchiOSLX7L74ng1Dmao=";
=======
        sha256 = "sha256-VG7+2dfu09nvHWuSAB6sLGMmjRCDCysl/9FR1WSF21k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
    ];

    extraNativeBuildInputs = [ autoreconfHook ];
<<<<<<< HEAD
=======
    extraMeta.knownVulnerabilities = [ "CVE-2023-28531" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
