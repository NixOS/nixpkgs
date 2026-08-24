{
  lib,
  dotnet-sdk,
  dotnetCorePackages,
  stdenv,
  writeText,
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

    let
      runtime = dotnet-sdk_target.runtime;

      targetFramework = "net${lib.versions.majorMinor runtime.version}";

      props = writeText "framework.props" ''
        <Project>
          <ItemGroup>
            <KnownFrameworkReference Update="@(KnownFrameworkReference)">
              <TargetingPackVersion Condition="'%(TargetFramework)' == '${targetFramework}'">${runtime.version}</TargetingPackVersion>
            </KnownFrameworkReference>
            <KnownAppHostPack Update="@(KnownAppHostPack)">
              <AppHostPackVersion Condition="'%(TargetFramework)' == '${targetFramework}'">${runtime.version}</AppHostPackVersion>
            </KnownAppHostPack>
          </ItemGroup>
        </Project>
      '';
    in

    stdenv.mkDerivation {
      name = "dotnet-cross-target-${runtime.version}-from-${dotnet-sdk.version}-test";

      nativeBuildInputs = [
        (dotnetCorePackages.combinePackages [
          dotnet-sdk
          runtime
        ])
      ]
      ++ dotnet-sdk_target.packages;

      unpackPhase = ''
        runHook preUnpack
        mkdir test
        cd test
        cp ${props} Directory.Build.props
        ${dotnet-sdk_target}/bin/dotnet new console --no-restore
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        dotnet run
        touch "$out"
        runHook postInstall
      '';
    };

in
lib.optionalAttrs (!dotnet-sdk.hasCrossTargetBug) (
  lib.recurseIntoAttrs (
    lib.mapAttrs (_: mkTest) (
      lib.filterAttrs (
        _: target:
        lib.versionOlder (lib.versions.major target.runtime.version) (
          lib.versions.major dotnet-sdk.runtime.version
        )
      ) sdks
    )
  )
)
