{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20240218";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-YlspL4BS/7vv59nW+9+cjR/Bi1yFVo8lRwl9l8VAvXU=";
  };

  meta = with lib; {
    description = "Tests the compatibility of so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "vttest";
  };
}
