{ lib, stdenvNoCC, fetchurl, unzip }:

let
  rev = "46a20517c33efbb8bb34e335c3534d08bd049c48";
in
stdenvNoCC.mkDerivation {
  pname = "longfox";
  version = "unstable-2019-07-24";

  src = fetchurl {
    url = "https://git.pleroma.social/pleroma/emoji-index/-/raw/${rev}/packs/longfox.zip";
    hash = "sha256-KrXyWkY6g2oJdXntCnOhkG7MBZvKXiaPwa+dLqOlrMU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Longfox emoji repacked as APNG";
    license = licenses.asl20;
    maintainers = with maintainers; [ cafkafk ];
  };
}
