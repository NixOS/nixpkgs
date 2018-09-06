{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libnl }:

let
  sourceAttrs = (import ./source.nix) { inherit fetchFromGitHub; };
in

stdenv.mkDerivation {
  name = "jool-cli-${sourceAttrs.version}";

  src = sourceAttrs.src;

  setSourceRoot = ''
    sourceRoot=$(echo */usr)
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libnl ];

  postPatch = ''
    chmod u+w -R ../common
  '';

  meta = with stdenv.lib; {
    homepage = https://www.jool.mx/;
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - CLI tools";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
  };
}
