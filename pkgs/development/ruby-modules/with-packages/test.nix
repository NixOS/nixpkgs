# a generic test suite for all gems for all ruby versions.
# use via nix-build.
let
  pkgs = import ../../../.. {};
  lib = pkgs.lib;
  stdenv = pkgs.stdenv;

  rubyVersions = with pkgs; [
    ruby_2_4
    ruby_2_5
    ruby_2_6
    ruby_2_7
  ];

  gemTests =
    (lib.mapAttrs
      (name: gem: [ name ])
      pkgs.ruby.gems) //
    (import ./require_exceptions.nix);

  tests = ruby:
    lib.mapAttrs (name: gem:
      let
        test =
          if builtins.isList gemTests.${name}
          then pkgs.writeText "${name}.rb" ''
                puts "${name} GEM_HOME: #{ENV['GEM_HOME']}"
                ${lib.concatStringsSep "\n" (map (n: "require '${n}'") gemTests.${name})}
              ''
          else pkgs.writeText "${name}.rb" gemTests.${name};

        deps = ruby.withPackages (g: [ g.${name} ]);
      in stdenv.mkDerivation {
        name = "test-gem-${ruby.name}-${name}";
        buildInputs = [ deps ];
        buildCommand = ''
          INLINEDIR=$PWD ruby ${test}
          touch $out
        '';
      }
    ) ruby.gems;
in
  stdenv.mkDerivation {
    name = "test-all-ruby-gems";
    buildInputs = builtins.foldl' (sum: ruby: sum ++ ( builtins.attrValues (tests ruby) )) [] rubyVersions;
    buildCommand = ''
      touch $out
    '';
  }
