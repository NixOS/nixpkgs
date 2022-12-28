{ lib, stdenv, fetchFromGitHub }:

{
  # : string
  pname
  # : string
, version
  # : string
, sha256
  # : string
, description
  # : list Maintainer
, maintainers
  # : license
, license ? lib.licenses.isc
  # : string
, owner ? "flexibeast"
  # : string
, rev ? "v${version}"
}:

let
  manDir = "${placeholder "out"}/share/man";

  src = fetchFromGitHub {
    inherit owner rev sha256;
    repo = pname;
  };
in

stdenv.mkDerivation {
  inherit pname version src;

  makeFlags = [
    "MANPATH=${manDir}"
  ];

  dontBuild = true;

  meta = with lib; {
    inherit description license maintainers;
    inherit (src.meta) homepage;
    platforms = platforms.all;
  };
}
