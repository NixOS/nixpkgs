{
  lib,
  mkKdeDerivation,
  qtdeclarative,
  qttools,
  perl,
}:
mkKdeDerivation {
  pname = "syntax-highlighting";

  extraBuildInputs = [ qtdeclarative ];
  extraNativeBuildInputs = [
    qttools
    perl
  ];
  meta = {
    mainProgram = "ksyntaxhighlighter6";
    platforms = lib.platforms.linux ++ lib.platforms.freebsd ++ lib.platforms.darwin;
  };
}
