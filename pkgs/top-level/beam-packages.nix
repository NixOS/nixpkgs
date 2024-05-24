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

  # Aliases added 2023-03-21
  versionLoop = f: lib.lists.foldr (version: acc: (f version) // acc) { } [ "26" "25" ];

  interpretersAliases = versionLoop (version: {
    "erlangR${version}" = self.interpreters."erlang_${version}";
    "erlangR${version}_odbc" = self.interpreters."erlang_${version}_odbc";
    "erlangR${version}_javac" = self.interpreters."erlang_${version}_javac";
    "erlangR${version}_odbc_javac" = self.interpreters."erlang_${version}_odbc_javac";
  });

  packagesAliases = versionLoop (version: { "erlangR${version}" = self.packages."erlang_${version}"; });

in

{
  beamLib = callPackage ../development/beam-modules/lib.nix { };

  latestVersion = "erlang_25";

  # Each
  interpreters = {

    erlang = self.interpreters.${self.latestVersion};
    erlang_odbc = self.interpreters."${self.latestVersion}_odbc";
    erlang_javac = self.interpreters."${self.latestVersion}_javac";
    erlang_odbc_javac = self.interpreters."${self.latestVersion}_odbc_javac";

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
    erlang_26_odbc = self.interpreters.erlang_26.override { odbcSupport = true; };
    erlang_26_javac = self.interpreters.erlang_26.override { javacSupport = true; };
    erlang_26_odbc_javac = self.interpreters.erlang_26.override {
      javacSupport = true;
      odbcSupport = true;
    };

    erlang_25 = self.beamLib.callErlang ../development/interpreters/erlang/25.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlang_25_odbc = self.interpreters.erlang_25.override { odbcSupport = true; };
    erlang_25_javac = self.interpreters.erlang_25.override { javacSupport = true; };
    erlang_25_odbc_javac = self.interpreters.erlang_25.override {
      javacSupport = true;
      odbcSupport = true;
    };

    erlang_24 = self.beamLib.callErlang ../development/interpreters/erlang/24.nix {
      wxGTK = wxGTK32;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlang_24_odbc = self.interpreters.erlang_24.override { odbcSupport = true; };
    erlang_24_javac = self.interpreters.erlang_24.override { javacSupport = true; };
    erlang_24_odbc_javac = self.interpreters.erlang_24.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlang_24.elixir`.
    inherit (self.packages.erlang)
      elixir elixir_1_16 elixir_1_15 elixir_1_14 elixir_1_13 elixir_1_12 elixir_1_11 elixir_1_10 elixir-ls lfe lfe_2_1;
  } // interpretersAliases;

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang:
    callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    erlang = self.packages.${self.latestVersion};

    erlang_26 = self.packagesWith self.interpreters.erlang_26;
    erlang_25 = self.packagesWith self.interpreters.erlang_25;
    erlang_24 = self.packagesWith self.interpreters.erlang_24;
  } // packagesAliases;

  __attrsFailEvaluation = true;
}
