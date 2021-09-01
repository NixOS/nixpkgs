{ bundlerApp, makeWrapper }:

bundlerApp {
  pname = "bolt";
  gemdir = ./.;
  exes = [ "bolt" ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    # Set BOLT_GEM=1 to remove warning
    wrapProgram $out/bin/bolt --set BOLT_GEM 1
  '';
}
