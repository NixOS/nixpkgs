{ pkgs, stdenv, callPackage }:

rec {
  lib = import ../development/beam-modules/lib.nix { inherit pkgs; };

  interpreter = rec {

    erlangR16 = lib.callErlang ../development/interpreters/erlang/R16.nix {};
    erlangR17 = lib.callErlang ../development/interpreters/erlang/R17.nix {};
    erlangR18 = lib.callErlang ../development/interpreters/erlang/R18.nix {};
    erlangR19 = lib.callErlang ../development/interpreters/erlang/R19.nix {};

    elixir126 = packages.elixir126.elixir;
    elixir131 = packages.elixir131.elixir;

  };

  packages = rec {

    erlangR16 = callPackage ../development/beam-modules {
      erlang = interpreter.erlangR16;
    };

    erlangR17 = callPackage ../development/beam-modules {
      erlang = interpreter.erlangR17;
    };

    erlangR18 = callPackage ../development/beam-modules {
      erlang = interpreter.erlangR18;
    };

    erlangR19 = callPackage ../development/beam-modules {
      erlang = { erlang = interpreter.erlangR19; };
    };

    elixir126 = callPackage ../development/beam-modules {
      erlang = interpreter.erlangR18;
      interpreterConfig = lib.overrideElixir ../development/interpreters/elixir/1.2.6.nix;
    };

    elixir131 = callPackage ../development/beam-modules {
      erlang = interpreter.erlangR18;
      interpreterConfig = lib.overrideElixir ../development/interpreters/elixir/1.3.1.nix;
    };

    elixir131_R19 = callPackage ../development/beam-modules {
      erlang = interpreter.erlangR19;
      interpreterConfig = lib.overrideElixir ../development/interpreters/elixir/1.3.1.nix;
    };

  };
}
