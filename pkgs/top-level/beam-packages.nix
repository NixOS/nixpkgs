{
  config,
  lib,
  beam,
  callPackage,
  stdenv,
  wxSupport ? true,
  systemd,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  __splicedPackages,
  # Name of this set in `pkgs`, needed to splice the package sets it builds.
  scopeName,
}:

let
  self = beam;

  pkgs = __splicedPackages;
  callErlang =
    drv: args:
    let
      genericBuilder =
        versionArgs: import ../development/interpreters/erlang/generic-builder.nix (versionArgs // args);
    in
    pkgs.callPackage (import drv genericBuilder) { };

  packagesFor =
    name: erlang:
    callPackage ../development/beam-modules {
      inherit erlang;
      splicePath = [
        scopeName
        "packages"
        name
      ];
    };
in

{
  latestVersion = "erlang_28";

  # Each
  interpreters = {

    erlang = self.interpreters.${self.latestVersion};

    # Standard Erlang versions, using the generic builder.
    #
    # Three versions are supported according to https://github.com/erlang/otp/security

    erlang_29 = callErlang ../development/interpreters/erlang/29.nix {
      inherit wxSupport systemdSupport;
    };

    erlang_28 = callErlang ../development/interpreters/erlang/28.nix {
      inherit wxSupport systemdSupport;
    };

    erlang_27 = callErlang ../development/interpreters/erlang/27.nix {
      inherit wxSupport systemdSupport;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlang_27.elixir`.
    inherit (self.packages.erlang)
      elixir
      elixir_1_20
      elixir_1_19
      elixir_1_18
      elixir_1_17
      elixir-ls
      lfe
      ;

  };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    erlang = self.packages.${self.latestVersion};
    erlang_29 = packagesFor "erlang_29" self.interpreters.erlang_29;
    erlang_28 = packagesFor "erlang_28" self.interpreters.erlang_28;
    erlang_27 = packagesFor "erlang_27" self.interpreters.erlang_27;
  }
  // lib.optionalAttrs config.allowAliases {
    erlang_26 = throw "'erlang_26' has been removed, as it is EOL"; # added 2026-04-01
  };
}
// lib.optionalAttrs config.allowAliases {
  erlang_26 = throw "'erlang_26' has been removed, as it is EOL"; # added 2026-04-01

  elixir_1_16 = throw "'elixir_1_16' has been removed, due to the removal of erlang_26 as EOL"; # added 2026-04-01
  elixir_1_15 = throw "'elixir_1_15' has been removed, due to the removal of erlang_26 as EOL"; # added 2026-04-01

  packagesWith = throw "'beam.packagesWith' has been removed, as such sets cannot be cross compiled. Use an OTP specific set, e.g. 'beam27Packages', and 'overrideScope' to change any of its members."; # added 2026-08-18
}
