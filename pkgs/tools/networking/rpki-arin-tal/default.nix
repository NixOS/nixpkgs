{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "rpki-arin-tal";
  version = "1.0";

  src = fetchurl {
    url = "https://www.arin.net/resources/manage/rpki/arin.tal";
    hash = "sha256-T2weRW/lq0aL6sFJXlfZmh7uqk2fnjRRnq9YhXwhr0g=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -m 644 $src ${placeholder "out"}/arin.tal
    runHook postInstall
  '';

  meta = with lib; {
    description = "ARINs RPKI Trust Anchor Locator";
    longDescription = ''
      ARIN's RPKI Trust Anchor Locator (TAL)
      With downloading this package you aggree to the ARIN RPA
      https://www.arin.net/resources/manage/rpki/rpa_092622.pdf

      Context: https://mailman.nanog.org/pipermail/nanog/2022-October/220786.html
    '';
    homepage = "https://www.openbsd.org/rpki-client/portable.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ vidister ];
    platforms = with platforms; all;
  };
}
