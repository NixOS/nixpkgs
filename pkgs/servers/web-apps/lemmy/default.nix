{ darwin, nodejs_18, lib, newScope }:

lib.makeScope newScope (self:
let
  inherit (self) callPackage;
in
{
  lemmy-server = callPackage
    (import ./server.nix {
      pin = ./pin.json;
      # `cargo test` fails as `tokio::test` relies on the macros feature which wasn't specified in Cargo.toml
      patches = [ ./tokio-macros.patch ];
    })
    {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

  lemmy-serverUnstable = callPackage
    (import ./server.nix {
      pin = ./pin-unstable.json;
    })
    {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

  lemmy-ui = callPackage
    (import ./ui.nix {
      pin = ./pin.json;
      packageJSON = ./package.json;
    })
    {
      nodejs = nodejs_18;
    };

  lemmy-uiUnstable = callPackage
    (import ./ui.nix {
      pin = ./pin-unstable.json;
      packageJSON = ./package-unstable.json;
    })
    {
      nodejs = nodejs_18;
    };
})
