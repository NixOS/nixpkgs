{ lib
, beam
, callPackage
, wxGTK32
, buildPackages
, stdenv
, wxSupport ? true
, systemd
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

let
  self = beam;

in

{
  beamLib = callPackage ../development/beam-modules/lib.nix { };

  latestVersion = "erlang_25";

  # Each
  interpreters = {

    erlang = self.interpreters.${self.latestVersion};

    # Standard Erlang versions, using the generic builder.

    erlang_27 = self.beamLib.callErlang ../development/interpreters/erlang/27.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      exdocSupport = true;
      exdoc = self.packages.erlang_26.ex_doc;
      inherit wxSupport systemdSupport;
    };

    erlang_26 = self.beamLib.callErlang ../development/interpreters/erlang/26.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };

    erlang_25 = self.beamLib.callErlang ../development/interpreters/erlang/25.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };

    erlang_24 = self.beamLib.callErlang ../development/interpreters/erlang/24.nix {
      wxGTK = wxGTK32;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlang_24.elixir`.
    inherit (self.packages.erlang)
      elixir elixir_1_17 elixir_1_16 elixir_1_15 elixir_1_14 elixir_1_13 elixir_1_12 elixir_1_11 elixir_1_10 elixir-ls lfe lfe_2_1;
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang:
    callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    erlang = self.packages.${self.latestVersion};
    erlang_27 = self.packagesWith self.interpreters.erlang_27;
    erlang_26 = self.packagesWith self.interpreters.erlang_26;
    erlang_25 = self.packagesWith self.interpreters.erlang_25;
    erlang_24 = self.packagesWith self.interpreters.erlang_24;
  };

  __attrsFailEvaluation = true;
}
