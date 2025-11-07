{
  lib,
  beam,
  callPackage,
  stdenv,
  wxSupport ? true,
  systemd,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  __splicedPackages,
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
in

{
  latestVersion = "erlang_28";

  # Each
  interpreters = {

    erlang = self.interpreters.${self.latestVersion};

    # Standard Erlang versions, using the generic builder.
    #
    # Three versions are supported according to https://github.com/erlang/otp/security

    erlang_28 = callErlang ../development/interpreters/erlang/28.nix {
      inherit wxSupport systemdSupport;
    };

    erlang_27 = callErlang ../development/interpreters/erlang/27.nix {
      inherit wxSupport systemdSupport;
    };

    erlang_26 = callErlang ../development/interpreters/erlang/26.nix {
      inherit wxSupport systemdSupport;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlang_27.elixir`.
    inherit (self.packages.erlang)
      elixir
      elixir_1_19
      elixir_1_18
      elixir_1_17
      elixir_1_16
      elixir_1_15
      elixir-ls
      lfe
      ;
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang: callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    erlang = self.packages.${self.latestVersion};
    erlang_28 = self.packagesWith self.interpreters.erlang_28;
    erlang_27 = self.packagesWith self.interpreters.erlang_27;
    erlang_26 = self.packagesWith self.interpreters.erlang_26;
  };
}
