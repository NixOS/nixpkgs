{
  lib,
  pkgs,
  factor-unwrapped,
  overrides ? (self: super: { }),
}:

let
  inside =
    self:
    let
      callPackage = pkgs.newScope self;
    in
    lib.recurseIntoAttrs {

      buildFactorApplication =
        callPackage ../development/compilers/factor-lang/mk-factor-application.nix
          { };
      buildFactorVocab = callPackage ../development/compilers/factor-lang/mk-vocab.nix { };

      inherit factor-unwrapped;

      factor-lang = callPackage ../development/compilers/factor-lang/wrapper.nix { };
      factor-no-gui = callPackage ../development/compilers/factor-lang/wrapper.nix {
        guiSupport = false;
      };
      factor-minimal = callPackage ../development/compilers/factor-lang/wrapper.nix {
        enableDefaults = false;
        guiSupport = false;
      };
      factor-minimal-gui = callPackage ../development/compilers/factor-lang/wrapper.nix {
        enableDefaults = false;
      };

      # Vocabularies
      bresenham = callPackage ../development/factor-vocabs/bresenham { };

    }
    // lib.optionalAttrs pkgs.config.allowAliases {
      interpreter = throw "factorPackages now offers various wrapped factor runtimes (see documentation) and the buildFactorApplication helper.";
    };
  extensible-self = lib.makeExtensible (lib.extends overrides inside);
in
extensible-self
