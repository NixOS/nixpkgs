{ stdenv, name, preHook ? null, postHook ? null, initialPath, gcc, shell
, param1 ? "", param2 ? "", param3 ? "", param4 ? "", param5 ? ""
, extraAttrs ? {}
}:

let {

  stdenvGenerator = setupScript: rec {

    # The stdenv that we are producing.
    result =

      stdenv.mkDerivation {
        inherit name;

        builder = ./builder.sh;

        substitute = ../../build-support/substitute/substitute.sh;

        setup = setupScript;

        inherit preHook postHook initialPath gcc shell;

        # TODO: make this more elegant.
        inherit param1 param2 param3 param4 param5;
      }

      // {
    
        # Add a utility function to produce derivations that use this
        # stdenv and its shell.
        mkDerivation = attrs:
          (derivation (
            (removeAttrs attrs ["meta" "passthru"])
            //
            {
              builder = if attrs ? realBuilder then attrs.realBuilder else shell;
              args = if attrs ? args then attrs.args else
                ["-e" (if attrs ? builder then attrs.builder else ./default-builder.sh)];
              stdenv = result;
              system = result.system;
            })
          )
          # The meta attribute is passed in the resulting attribute set,
          # but it's not part of the actual derivation, i.e., it's not
          # passed to the builder and is not a dependency.  But since we
          # include it in the result, it *is* available to nix-env for
          # queries.
          //
          { meta = if attrs ? meta then attrs.meta else {}; }
          # Pass through extra attributes that are not inputs, but
          # should be made available to Nix expressions using the
          # derivation (e.g., in assertions).
          //
          (if attrs ? passthru then attrs.passthru else {});

        # Utility value: is this a Darwin system?
        isDarwin = result.system == "i686-darwin" || result.system == "powerpc-darwin";
        isLinux = result.system == "i686-linux" || result.system == "powerpc-linux";

        # Utility function: allow stdenv to be easily regenerated with
        # a different setup script.  (See all-packages.nix for an
        # example.)
        regenerate = stdenvGenerator;

      }

      # Propagate any extra attributes.  For instance, we use this to
      # "lift" packages like curl from the final stdenv for Linux to
      # all-packages.nix for that platform (meaning that it has a line
      # like curl = if stdenv ? curl then stdenv.curl else ...).
      // extraAttrs;

  }.result;

  
  body = stdenvGenerator ./setup.sh;

}
