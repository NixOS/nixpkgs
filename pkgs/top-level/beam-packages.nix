{ beam, callPackage, wxGTK30, buildPackages, stdenv
, wxSupport ? true
, systemdSupport ? stdenv.isLinux
}:

with beam; {
  lib = callPackage ../development/beam-modules/lib.nix { };

  # R24 is the default version.
  # The main switch to change default Erlang version.
  defaultVersion = "erlangR24";

  # Each
  interpreters = with beam.interpreters; {

    erlang = beam.interpreters.${defaultVersion};
    erlang_odbc = beam.interpreters."${defaultVersion}_odbc";
    erlang_javac = beam.interpreters."${defaultVersion}_javac";
    erlang_odbc_javac = beam.interpreters."${defaultVersion}_odbc_javac";

    # Standard Erlang versions, using the generic builder.

    # R25
    erlangR25 = lib.callErlang ../development/interpreters/erlang/R25.nix {
      wxGTK = wxGTK30;
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR25_odbc = erlangR25.override { odbcSupport = true; };
    erlangR25_javac = erlangR25.override { javacSupport = true; };
    erlangR25_odbc_javac = erlangR25.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R24
    erlangR24 = lib.callErlang ../development/interpreters/erlang/R24.nix {
      wxGTK = wxGTK30;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR24_odbc = erlangR24.override { odbcSupport = true; };
    erlangR24_javac = erlangR24.override { javacSupport = true; };
    erlangR24_odbc_javac = erlangR24.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R23
    erlangR23 = lib.callErlang ../development/interpreters/erlang/R23.nix {
      wxGTK = wxGTK30;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR23_odbc = erlangR23.override { odbcSupport = true; };
    erlangR23_javac = erlangR23.override { javacSupport = true; };
    erlangR23_odbc_javac = erlangR23.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R22
    erlangR22 = lib.callErlang ../development/interpreters/erlang/R22.nix {
      wxGTK = wxGTK30;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR22_odbc = erlangR22.override { odbcSupport = true; };
    erlangR22_javac = erlangR22.override { javacSupport = true; };
    erlangR22_odbc_javac = erlangR22.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R21
    erlangR21 = lib.callErlang ../development/interpreters/erlang/R21.nix {
      wxGTK = wxGTK30;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport systemdSupport;
    };
    erlangR21_odbc = erlangR21.override { odbcSupport = true; };
    erlangR21_javac = erlangR21.override { javacSupport = true; };
    erlangR21_odbc_javac = erlangR21.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlangR24.elixir`.
    inherit (packages.erlang)
      elixir elixir_1_13 elixir_1_12 elixir_1_11 elixir_1_10 elixir_1_9 elixir_ls;

    inherit (packages.erlang) lfe lfe_1_3;
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang:
    callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    # Packages built with default Erlang version.
    erlang = packages.${defaultVersion};

    erlangR25 = packagesWith interpreters.erlangR25;
    erlangR24 = packagesWith interpreters.erlangR24;
    erlangR23 = packagesWith interpreters.erlangR23;
    erlangR22 = packagesWith interpreters.erlangR22;
    erlangR21 = packagesWith interpreters.erlangR21;
  };
}
