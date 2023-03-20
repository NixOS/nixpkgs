{ lib, stdenv, fetchurl, memstreamHook }:

stdenv.mkDerivation rec {
  pname = "hyx";
  version = "2021.06.09";

  src = fetchurl {
    url = "https://yx7.cc/code/hyx/hyx-${lib.replaceStrings [ "-" ] [ "." ] version}.tar.xz";
    sha256 = "sha256-jU8U5YWE1syPBOQ8o4BC7tIYiCo4kknCCwhnMCVtpes=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace "-Wl,-z,relro,-z,now -fpic -pie" ""
  '';

  buildInputs = lib.optional (stdenv.system == "x86_64-darwin") memstreamHook;

  installPhase = ''
    install -vD hyx $out/bin/hyx
  '';

  meta = with lib; {
    description = "minimalistic but powerful Linux console hex editor";
    homepage = "https://yx7.cc/code/";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; linux ++ darwin;
  };
}
