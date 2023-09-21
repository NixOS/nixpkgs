{ coreutils, fetchurl, fping, lib, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "zs-wait4host";
  version = "0.3.2";

  src = fetchurl {
    url = "https://ytrizja.de/distfiles/${pname}-${version}.tar.gz";
    sha256 = "9F1264BDoGlRR7bWlRXhfyvxWio4ydShKmabUQEIz9I=";
  };

  postPatch = ''
    for i in zs-wait4host zs-wait4host-inf; do
      substituteInPlace "$i" \
        --replace '$(zs-guess-fping)' '${fping}/bin/fping' \
        --replace ' sleep ' ' ${coreutils}/bin/sleep ' \
        --replace '[ "$FPING" ] || exit 1' ""
    done
  '';

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin zs-wait4host zs-wait4host-inf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Wait for a host to come up/go down";
    homepage = "https://ytrizja.de/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.fogti ];
    platforms = platforms.all;
  };
}
