{ lib, callPackage, linkFarmFromDrvs, dotnetCorePackages }:

let
  inherit (dotnetCorePackages) sdk_6_0 sdk_7_0 sdk_8_0;

  dotnetTest = { name, path, sdks }:
    linkFarmFromDrvs name (lib.lists.map (sdk:
      callPackage path {
        dotnet-sdk = sdk;
        TargetFramework = "net${lib.versions.majorMinor (lib.getVersion sdk)}";
      }
    ) (sdks));
in
{
  simple-build = dotnetTest {
    name = "simple-build";
    path = ./simple-build;
    sdks = [ sdk_6_0 sdk_7_0 sdk_8_0 ];
  };
  project-references = dotnetTest {
    name = "project-references";
    path = ./project-references;
    sdks = [ sdk_6_0 sdk_7_0 sdk_8_0 ];
  };
  publish-trimmed = dotnetTest {
    name = "publish-trimmed";
    path = ./publish-trimmed;
    sdks = [ sdk_6_0 sdk_7_0 sdk_8_0 ];
  };
  publish-ready-to-run = dotnetTest {
    name = "publish-ready-to-run";
    path = ./publish-ready-to-run;
    sdks = [ sdk_6_0 sdk_7_0 sdk_8_0 ];
  };
}
