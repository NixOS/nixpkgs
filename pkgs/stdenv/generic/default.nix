{ stdenv, name, preHook ? null, postHook ? null, initialPath, gcc
, param1 ? "", param2 ? "", param3 ? "", param4 ? "", param5 ? ""
}:

derivation {
  inherit stdenv name;
  system = stdenv.system;

  builder = ./builder.sh;

  setup = ./setup.sh;

  inherit preHook postHook initialPath gcc;

  # TODO: make this more elegant.
  inherit param1 param2 param3 param4 param5;
}
