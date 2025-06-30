{
  lib,
  fetchzip,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
}:
let
  version = "26780de81b8c14d48fe8d757c642086f2af2a66b";

  srcs = [
    (fetchFromGitHub {
      owner = "philippj";
      repo = "SteamworksPy";
      rev = version;
      hash = "sha256-nSGkEP6tny/Kv2+YjldFCYrLe1jnKOTa+w1/KCpSLsU=";

    })
    (fetchzip {
      url = "https://web.archive.org/web/20250527013243/https://partner.steamgames.com/downloads/steamworks_sdk_162.zip";
      hash = "sha256-yDA92nGj3AKTNI4vnoLaa+7mDqupQv0E4YKRRUWqyZw=";
    })
  ];

  library = stdenv.mkDerivation {
    pname = "steamworkspy-c";
    inherit version;

    unpackPhase = ''
      runHook preUnpack

      cp -r ${builtins.elemAt srcs 0} source
      chmod -R 755 source
      cp -r ${builtins.elemAt srcs 1}/public/steam source/library/sdk/
      cp ${builtins.elemAt srcs 1}/redistributable_bin/linux64/libsteam_api.so source/library/

      runHook postUnpack
    '';

    sourceRoot = "source/library";

    installPhase = ''
      mkdir -p $out
      cp SteamworksPy.so $out/
    '';
  };
in

buildPythonPackage {
  pname = "steamworkspy";
  inherit version;

  src = builtins.elemAt srcs 0;

  postInstall = ''
    cp ${library}/SteamworksPy.so $out/lib
  '';

  meta = {
    description = "Python API system for Valve's Steamworks";
    homepage = "https://github.com/philippj/SteamworksPy";
    license = with lib.licenses; [
      mit
      (
        unfreeRedistributable
        // {
          url = "https://partner.steamgames.com/documentation/sdk_access_agreement";
        }
      )
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ weirdrock ];
  };
}
