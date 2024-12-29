{
  stdenv,
  lib,
  buildEnv,
  buildRubyGem,
  ruby,
  gemConfig,
  makeBinaryWrapper,
}:

/*
  Example usage:
  nix-shell -E "(import <nixpkgs> {}).ruby.withPackages (pkgs: with pkgs; [ pry nokogiri ])"

  You can also use this for writing ruby scripts that run anywhere that has nix
  using a nix-shell shebang:
    #!/usr/bin/env nix-shell
    #!nix-shell -i ruby -p "ruby.withPackages (pkgs: with pkgs; [ pry nokogiri ])"

  Run the following in the nixpkgs root directory to update the ruby-packages.nix:
  ./maintainers/scripts/update-ruby-packages
*/

let
  functions = import ../bundled-common/functions.nix { inherit lib gemConfig; };

  buildGems =
    gemset:
    let
      realGemset = if builtins.isAttrs gemset then gemset else import gemset;
      builtGems = lib.mapAttrs (
        name: initialAttrs:
        let
          attrs = functions.applyGemConfigs (
            {
              inherit ruby;
              gemName = name;
            }
            // initialAttrs
          );
        in
        buildRubyGem (functions.composeGemAttrs ruby builtGems name attrs)
      ) realGemset;
    in
    builtGems;

  gems = buildGems (import ../../../top-level/ruby-packages.nix);

  withPackages =
    selector:
    let
      selected = selector gems;

      gemEnv = buildEnv {
        name = "ruby-gems";
        paths = selected;
        pathsToLink = [
          "/lib"
          "/bin"
          "/nix-support"
        ];
      };

      wrappedRuby = stdenv.mkDerivation {
        name = "wrapped-${ruby.name}";
        nativeBuildInputs = [ makeBinaryWrapper ];
        buildCommand = ''
          mkdir -p $out/bin
          for i in ${ruby}/bin/*; do
            makeWrapper "$i" $out/bin/$(basename "$i") --set GEM_PATH ${gemEnv}/${ruby.gemPath}
          done
        '';
      };

    in
    stdenv.mkDerivation {
      name = "${ruby.name}-with-packages";
      nativeBuildInputs = [ makeBinaryWrapper ];
      buildInputs = [
        selected
        ruby
      ];

      dontUnpack = true;

      installPhase = ''
        for i in ${ruby}/bin/* ${gemEnv}/bin/*; do
          rm -f $out/bin/$(basename "$i")
          makeWrapper "$i" $out/bin/$(basename "$i") --set GEM_PATH ${gemEnv}/${ruby.gemPath}
        done

        ln -s ${ruby}/nix-support $out/nix-support
      '';

      passthru = {
        inherit wrappedRuby;
        gems = selected;
      };
    };

in
{
  inherit withPackages gems buildGems;
}
