{
  lib,
  dotnet-sdk,
  dotnetCorePackages,
  stdenv,
}:

let
  sdks = {
    inherit (dotnetCorePackages)
      sdk_10_0
      sdk_9_0
      sdk_8_0
      ;
  };

  mkTest =
    dotnet-sdk_target:

    stdenv.mkDerivation {
      name = "dotnet-cross-target-${dotnet-sdk_target.version}-test";

      nativeBuildInputs = [
        (dotnetCorePackages.combinePackages [
          dotnet-sdk
          dotnet-sdk_target
        ])
      ]
      ++ dotnet-sdk_target.packages;

      unpackPhase = ''
        runHook preUnpack
        mkdir test
        cd test
        ${dotnet-sdk_target}/bin/dotnet new console --no-restore
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        dotnet run > $out
        runHook postInstall
      '';
    };

in
lib.recurseIntoAttrs (lib.mapAttrs (_: mkTest) sdks)
