{ lib
, beam
, callPackage
, openssl_1_1
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

  latestVersion = "erlangR25";

  # Each
  interpreters = {

    erlang = self.interpreters.${self.latestVersion};
    erlang_odbc = self.interpreters."${self.latestVersion}_odbc";
    erlang_javac = self.interpreters."${self.latestVersion}_javac";
    erlang_odbc_javac = self.interpreters."${self.latestVersion}_odbc_javac";

    # Standard Erlang versions, using the generic builder.

    # R25
    erlangR25 = self.beamLib.callErlang ../development/interpreters/erlang/R25.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR25_odbc = self.interpreters.erlangR25.override { odbcSupport = true; };
    erlangR25_javac = self.interpreters.erlangR25.override { javacSupport = true; };
    erlangR25_odbc_javac = self.interpreters.erlangR25.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R24
    erlangR24 = self.beamLib.callErlang ../development/interpreters/erlang/R24.nix {
      wxGTK = wxGTK32;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR24_odbc = self.interpreters.erlangR24.override { odbcSupport = true; };
    erlangR24_javac = self.interpreters.erlangR24.override { javacSupport = true; };
    erlangR24_odbc_javac = self.interpreters.erlangR24.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R23
    erlangR23 = self.beamLib.callErlang ../development/interpreters/erlang/R23.nix {
      openssl = openssl_1_1;
      wxGTK = wxGTK32;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR23_odbc = self.interpreters.erlangR23.override { odbcSupport = true; };
    erlangR23_javac = self.interpreters.erlangR23.override { javacSupport = true; };
    erlangR23_odbc_javac = self.interpreters.erlangR23.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R22
    erlangR22 = self.beamLib.callErlang ../development/interpreters/erlang/R22.nix {
      openssl = openssl_1_1;
      wxGTK = wxGTK32;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR22_odbc = self.interpreters.erlangR22.override { odbcSupport = true; };
    erlangR22_javac = self.interpreters.erlangR22.override { javacSupport = true; };
    erlangR22_odbc_javac = self.interpreters.erlangR22.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R21
    erlangR21 = self.beamLib.callErlang ../development/interpreters/erlang/R21.nix {
      openssl = openssl_1_1;
      wxGTK = wxGTK32;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR21_odbc = self.interpreters.erlangR21.override { odbcSupport = true; };
    erlangR21_javac = self.interpreters.erlangR21.override { javacSupport = true; };
    erlangR21_odbc_javac = self.interpreters.erlangR21.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlangR24.elixir`.
    inherit (self.packages.erlang)
      elixir elixir_1_14 elixir_1_13 elixir_1_12 elixir_1_11 elixir_1_10 elixir_ls;

    inherit (self.packages.erlang) lfe lfe_1_3;
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang:
    callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    erlang = self.packages.${self.latestVersion};

    erlangR25 = self.packagesWith self.interpreters.erlangR25;
    erlangR24 = self.packagesWith self.interpreters.erlangR24;
    erlangR23 = self.packagesWith self.interpreters.erlangR23;
    erlangR22 = self.packagesWith self.interpreters.erlangR22;
    erlangR21 = self.packagesWith self.interpreters.erlangR21;
  };
}
