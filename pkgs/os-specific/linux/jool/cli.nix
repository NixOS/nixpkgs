<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, nixosTests
, autoreconfHook, pkg-config, libnl, iptables
}:
=======
{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, libnl, iptables }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  sourceAttrs = (import ./source.nix) { inherit fetchFromGitHub; };
in

stdenv.mkDerivation {
  pname = "jool-cli";
  version = sourceAttrs.version;

  src = sourceAttrs.src;

<<<<<<< HEAD
  patches = [
    ./validate-config.patch
  ];
=======
  patches = [ (fetchpatch {
    url = "https://github.com/NICMx/Jool/commit/490ddb0933061cab3c2a7952dffc61789deed565.patch";
    hash = "sha256-1dpMth0ocPHujlk+96St1a63RipcWiL/CdmSz4O87Lg=";
  }) ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libnl iptables ];

  makeFlags = [ "-C" "src/usr" ];

  prePatch = ''
    sed -e 's%^XTABLES_SO_DIR = .*%XTABLES_SO_DIR = '"$out"'/lib/xtables%g' -i src/usr/iptables/Makefile
  '';

<<<<<<< HEAD
  passthru.tests = { inherit (nixosTests) jool; };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://www.jool.mx/";
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - CLI tools";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
  };
}
