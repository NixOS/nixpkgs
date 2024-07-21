{ lib
, stdenv
, fetchurl
, bison
, flex
, gccmakedep
, imake
, libXau
, libXaw
, libXext
, libXpm
, libXt
, xorgcffiles
, xorgproto
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nas";
  version = "1.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/nas/nas-${finalAttrs.version}.tar.gz";
    hash = "sha256-t4hK+zj+7AOhlr07fpxHuAPIMOzRDXRV6cl+Eiw3lEw=";
  };

  nativeBuildInputs = [
    bison
    flex
    gccmakedep
    imake
  ];

  buildInputs = [
    libXau
    libXaw
    libXext
    libXpm
    libXt
    xorgproto
  ];

  buildFlags = [ "WORLDOPTS=" "World" ];

  installFlags = [ "LDLIBS=-lfl" "DESTDIR=${placeholder "out"}" ];

  postInstall = ''
    mv $out/${xorgcffiles}/* $out
    rm -fr $out/nix
  '';

  meta = {
    homepage = "http://radscan.com/nas.html";
    description = "Network transparent, client/server audio transport system";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
