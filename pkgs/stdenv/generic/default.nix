{ stdenv, name, preHook ? null, postHook ? null, initialPath, gcc, shell
, param1 ? "", param2 ? "", param3 ? "", param4 ? "", param5 ? ""
}:

let {

  body =

    stdenv.mkDerivation {
      inherit name;

      builder = ./builder.sh;

      substitute = ../../build-support/substitute/substitute.sh;

      setup = ./setup.sh;

      inherit preHook postHook initialPath gcc shell;

      # TODO: make this more elegant.
      inherit param1 param2 param3 param4 param5;
    }

    # Add a utility function to produce derivations that use this
    # stdenv and its shell.
    // {
      mkDerivation = attrs: derivation (attrs // {
        builder = if attrs ? realBuilder then attrs.realBuilder else shell;
        args = if attrs ? args then attrs.args else
          ["-e" (if attrs ? builder then attrs.builder else ./default-builder.sh)];
        stdenv = body;
        system = body.system;
      });
    };

}
