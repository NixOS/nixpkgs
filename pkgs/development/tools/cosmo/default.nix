{
  lib,
  stdenvNoCC,
  fetchurl,
}: let
  system = stdenvNoCC.hostPlatform.system;
  version = "0.18.4";

  hash =
    {
      aarch64-darwin = "sha256-Nk/mhtgdOISc9JbnZAEQ/g6ubie+SnRM729zpG6/lo4=";
      aarch64-linux = "sha256-lPXbbF/Zr1+XRB04KxnVt7DxpJCN5xCinTxPDDg4h2Y=";
      x86_64-darwin = "sha256-tCjhQXsfyePHHeTz3zoz+dp9MPGo7ST1bGQjaM1OBgk=";
      x86_64-linux = "sha256-bwvOJAr0KoAI808OaGZB5uhG1J0dzrodr3ZXK5/9S7Q=";
      x86_64-windows = "sha256-3W/QzY7jcVxGkHsEsfNyhvDzca2TC/sTxN5/AOFZz/g=";
    }
    .${system}
    or (throw "Unsupported system: ${system}");
in
  stdenvNoCC.mkDerivation rec {
    inherit
      version
      ;
    pname = "cosmo";

    preferLocalBuild = true;
    dontUnpack = true;

    src = fetchurl {
      inherit
        hash
        ;
      url = "https://cosmonic.sh/cosmo-${system}-${version}";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $src $out/bin/cosmo
      chmod +x $out/bin/cosmo

      runHook postInstall
    '';

    meta = with lib; {
      description = "Leverage the power and flexibility of WebAssembly. Take your ideas from concept to deployed anywhere, at scale, in minutes.";
      homepage = "https://cosmonic.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [rvolosatovs];
      platforms = with platforms; linux ++ darwin ++ windows;
    };
  }
