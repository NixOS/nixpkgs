{ lib, stdenv, fetchurl, dpkg, makeWrapper, steam-run }:

stdenv.mkDerivation rec {
  pname = "r2modman";
  version = "3.1.39";

  src = fetchurl {
    url = "https://github.com/ebkr/r2modmanPlus/releases/download/v${version}/r2modman_${version}_amd64.deb ";
    sha256 = "sha256-Wy3C7acAD5g//DVua+8v3jGF3qHXnu/3vR2e0wcHCKk=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  unpackCmd = "dpkg -x $curSrc src";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r opt/ usr/share/ $out

    mkdir $out/bin
    ln -s $out/opt/r2modman/r2modman $out/bin/

    substituteInPlace $out/share/applications/r2modman.desktop \
      --replace /opt/ $out/opt/

    runHook postInstall
  '';

  # Wrap program with steam-run, as it needs steam's dependencies
  # to interact with steam and run games.
  postFixup = ''
    mv $out/opt/r2modman/r2modman $out/opt/r2modman/.r2modman-unwrapped
    makeWrapper ${steam-run}/bin/steam-run $out/opt/r2modman/r2modman \
      --add-flags $out/opt/r2modman/.r2modman-unwrapped \
      --add-flags --no-sandbox \
      --prefix LD_LIBRARY_PATH : $out/opt/r2modman \
      --argv0 r2modman
  '';

  meta = with lib; {
    description = "A simple and easy to use mod manager for several games using Thunderstore";
    homepage = "https://github.com/ebkr/r2modmanPlus";
    downloadPage = "https://github.com/ebkr/r2modmanPlus/releases";
    changelog = "https://github.com/ebkr/r2modmanPlus/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
