{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libnl }:

let
  sourceAttrs = (import ./source.nix) { inherit fetchFromGitHub; };
in

stdenv.mkDerivation {
  name = "jool-cli-${sourceAttrs.version}";

  src = sourceAttrs.src;

  sourceRoot = "Jool-v${sourceAttrs.version}-src/usr";

  buildInputs = [ autoreconfHook pkgconfig libnl ];

  postPatch = ''
    chmod u+w -R ../common
  '';

  meta = with stdenv.lib; {
    homepage = https://www.jool.mx/;
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - CLI tools";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
