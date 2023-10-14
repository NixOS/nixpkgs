{ lib
, stdenvNoCC
, fetchurl
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "softnet";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/cirruslabs/softnet/releases/download/${finalAttrs.version}/softnet.tar.gz";
    sha256 = "1g274x524xc85hfzxi3vb4xp720bjgk740bp6hc92d1ikmp0b664";
  };
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -D softnet $out/bin/softnet
    install -Dm444 -t $out/share/softnet README.md LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    description = "Software networking with isolation for Tart";
    homepage = "https://github.com/cirruslabs/softnet";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "aarch64-darwin" ];
    # Source build will be possible after darwin SDK 12.0 bump
    # https://github.com/NixOS/nixpkgs/pull/229210
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
