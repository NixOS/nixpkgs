{ callPackage, wxGTK30, openssl_1_0_2, buildPackages, wxSupport ? true }:

rec {
  lib = callPackage ../development/beam-modules/lib.nix { };

  # Each
  interpreters = rec {

    # R23 is the default version.
    erlang = erlangR23; # The main switch to change default Erlang version.
    erlang_odbc = erlangR23_odbc;
    erlang_javac = erlangR23_javac;
    erlang_odbc_javac = erlangR23_odbc_javac;

    # Standard Erlang versions, using the generic builder.

    # R23
    erlangR23 = lib.callErlang ../development/interpreters/erlang/R23.nix {
      wxGTK = wxGTK30;
      # Can be enabled since the bug has been fixed in https://github.com/erlang/otp/pull/2508
      parallelBuild = true;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport;
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
      inherit wxSupport;
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
      inherit wxSupport;
    };
    erlangR21_odbc = erlangR21.override { odbcSupport = true; };
    erlangR21_javac = erlangR21.override { javacSupport = true; };
    erlangR21_odbc_javac = erlangR21.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R20
    erlangR20 = lib.callErlang ../development/interpreters/erlang/R20.nix {
      wxGTK = wxGTK30;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport;
    };
    erlangR20_odbc = erlangR20.override { odbcSupport = true; };
    erlangR20_javac = erlangR20.override { javacSupport = true; };
    erlangR20_odbc_javac = erlangR20.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R19
    erlangR19 = lib.callErlang ../development/interpreters/erlang/R19.nix {
      wxGTK = wxGTK30;
      openssl = openssl_1_0_2;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport;
    };
    erlangR19_odbc = erlangR19.override { odbcSupport = true; };
    erlangR19_javac = erlangR19.override { javacSupport = true; };
    erlangR19_odbc_javac = erlangR19.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # R18
    erlangR18 = lib.callErlang ../development/interpreters/erlang/R18.nix {
      wxGTK = wxGTK30;
      openssl = openssl_1_0_2;
      autoconf = buildPackages.autoconf269;
      inherit wxSupport;
    };
    erlangR18_odbc = erlangR18.override { odbcSupport = true; };
    erlangR18_javac = erlangR18.override { javacSupport = true; };
    erlangR18_odbc_javac = erlangR18.override {
      javacSupport = true;
      odbcSupport = true;
    };

    # Basho fork, using custom builder.
    erlang_basho_R16B02 =
      lib.callErlang ../development/interpreters/erlang/R16B02-basho.nix {
        autoconf = buildPackages.autoconf269;
        inherit wxSupport;
      };
    erlang_basho_R16B02_odbc =
      erlang_basho_R16B02.override { odbcSupport = true; };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlangR23.elixir`.
    inherit (packages.erlang)
      elixir elixir_1_11 elixir_1_10 elixir_1_9 elixir_1_8 elixir_1_7 elixir_ls;

    inherit (packages.erlang) lfe lfe_1_2 lfe_1_3;
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang:
    callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    # Packages built with default Erlang version.
    erlang = packagesWith interpreters.erlang;

    erlangR23 = packagesWith interpreters.erlangR23;
    erlangR22 = packagesWith interpreters.erlangR22;
    erlangR21 = packagesWith interpreters.erlangR21;
    erlangR20 = packagesWith interpreters.erlangR20;
    erlangR19 = packagesWith interpreters.erlangR19;
    erlangR18 = packagesWith interpreters.erlangR18;
  };
}
