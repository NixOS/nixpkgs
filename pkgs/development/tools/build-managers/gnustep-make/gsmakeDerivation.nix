{ stdenv, lib, libobjc2, clang, gnustep_make, makeWrapper, which }:
{ buildInputs ? []
, ...} @ args:
stdenv.mkDerivation (args // {
  buildInputs = [ makeWrapper gnustep_make which ] ++ buildInputs;

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;

  GNUSTEP_MAKEFILES = "${gnustep_make}/share/GNUstep/Makefiles";
})
