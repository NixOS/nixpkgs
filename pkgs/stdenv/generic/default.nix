{ stdenv, name, preHook ? null, postHook ? null, initialPath, gcc, bash
, param1 ? "", param2 ? "", param3 ? "", param4 ? "", param5 ? ""
}:

let {

  body =

    stdenv.mkDerivation {
      inherit name;

      builder = ./builder.sh;

      setup = ./setup.sh;

      inherit preHook postHook initialPath gcc;

      # TODO: make this more elegant.
      inherit param1 param2 param3 param4 param5;
    }

    # Add a utility function to produce derivations that use this
    # stdenv and its the bash shell.
    // {
      mkDerivation = attrs: derivation (attrs // {
        builder = bash;
        args = ["-e" (if attrs ? builder then attrs.builder else ./default-builder.sh)];
        stdenv = body;
        system = body.system;
      });
    };

}
