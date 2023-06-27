{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, libnl, iptables }:

let
  sourceAttrs = (import ./source.nix) { inherit fetchFromGitHub; };
in

stdenv.mkDerivation {
  pname = "jool-cli";
  version = sourceAttrs.version;

  src = sourceAttrs.src;

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

  meta = with lib; {
    homepage = "https://www.jool.mx/";
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - CLI tools";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
  };
}
