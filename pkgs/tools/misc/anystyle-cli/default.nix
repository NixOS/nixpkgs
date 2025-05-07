{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv {
  pname = "anystyle-cli";
  version = "1.4.5";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "anystyle-cli";

  meta = {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage = "https://anystyle.io/";
    license = [ lib.licenses.bsd2 ];
    maintainers = [ lib.maintainers.shamilton ];
    mainProgram = "anystyle-cli";
    platforms = [ lib.platforms.unix ];
  };
}
