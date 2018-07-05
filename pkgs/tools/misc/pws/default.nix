{ wrapCommand, lib, bundlerEnv, ruby, xsel }:

let
  env = bundlerEnv {
    name = "pws-gems";
    inherit ruby;
    gemdir = ./.;
  };
in wrapCommand "pws" {
  inherit (env.gems.pws) version;
  executable = "${env}/bin/pws";
  makeWrapperArgs = ["--prefix PATH ${xsel}/bin"];
  meta = with lib; {
    description = "Command-line password safe";
    homepage    = https://github.com/janlelis/pws;
    license     = licenses.mit;
    maintainers = [ maintainers.swistak35 ];
    platforms   = platforms.unix;
  };
}
