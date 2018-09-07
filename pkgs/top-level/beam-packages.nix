{ callPackage, wxGTK30 }:

rec {
  lib = callPackage ../development/beam-modules/lib.nix {};

  # Each
  interpreters = rec {

    # R20 is the default version.
    erlang = erlangR20; # The main switch to change default Erlang version.
    erlang_odbc = erlangR20_odbc;
    erlang_javac = erlangR20_javac;
    erlang_odbc_javac = erlangR20_odbc_javac;
    erlang_nox = erlangR20_nox;

    # These are standard Erlang versions, using the generic builder.
    erlangR18 = lib.callErlang ../development/interpreters/erlang/R18.nix {
      wxGTK = wxGTK30;
    };
    erlangR18_odbc = erlangR18.override { odbcSupport = true; };
    erlangR18_javac = erlangR18.override { javacSupport = true; };
    erlangR18_odbc_javac = erlangR18.override {
      javacSupport = true; odbcSupport = true;
    };
    erlangR18_nox = erlangR18.override { wxSupport = false; };
    erlangR19 = lib.callErlang ../development/interpreters/erlang/R19.nix {
      wxGTK = wxGTK30;
    };
    erlangR19_odbc = erlangR19.override { odbcSupport = true; };
    erlangR19_javac = erlangR19.override { javacSupport = true; };
    erlangR19_odbc_javac = erlangR19.override {
      javacSupport = true; odbcSupport = true;
    };
    erlangR19_nox = erlangR19.override { wxSupport = false; };
    erlangR20 = lib.callErlang ../development/interpreters/erlang/R20.nix {
      wxGTK = wxGTK30;
    };
    erlangR20_odbc = erlangR20.override { odbcSupport = true; };
    erlangR20_javac = erlangR20.override { javacSupport = true; };
    erlangR20_odbc_javac = erlangR20.override {
      javacSupport = true; odbcSupport = true;
    };
    erlangR20_nox = erlangR20.override { wxSupport = false; };
    erlangR21 = lib.callErlang ../development/interpreters/erlang/R21.nix {
      wxGTK = wxGTK30;
    };
    erlangR21_odbc = erlangR21.override { odbcSupport = true; };
    erlangR21_javac = erlangR21.override { javacSupport = true; };
    erlangR21_odbc_javac = erlangR21.override {
      javacSupport = true; odbcSupport = true;
    };
    erlangR21_nox = erlangR21.override { wxSupport = false; };

    # Basho fork, using custom builder.
    erlang_basho_R16B02 = lib.callErlang ../development/interpreters/erlang/R16B02-basho.nix {
    };
    erlang_basho_R16B02_odbc = erlang_basho_R16B02.override {
      odbcSupport = true;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlangR19.elixir`.
    inherit (packages.erlang) elixir elixir_1_7 elixir_1_6 elixir_1_5 elixir_1_4 elixir_1_3;

    inherit (packages.erlang) lfe lfe_1_2;
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang: callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = rec {

    # Packages built with default Erlang version.
    erlang = packagesWith interpreters.erlang;
    erlangR18 = packagesWith interpreters.erlangR18;
    erlangR19 = packagesWith interpreters.erlangR19;
    erlangR20 = packagesWith interpreters.erlangR20;
    erlangR21 = packagesWith interpreters.erlangR21;

  };
}
