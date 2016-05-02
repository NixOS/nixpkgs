{ stdenv, lib, bundlerEnv, ruby, xsel, makeWrapper }:

stdenv.mkDerivation rec {
  name = "pws-1.0.6";

  env = bundlerEnv {
    name = "${name}-gems";

    inherit ruby;

    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
  };

  buildInputs = [ makeWrapper ];

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/pws $out/bin/pws \
      --set PATH '"${xsel}/bin/:$PATH"'
  '';

  meta = with lib; {
    description = "Command-line password safe";
    homepage    = https://github.com/janlelis/pws;
    license     = licenses.mit;
    maintainers = maintainers.swistak35;
    platforms   = platforms.unix;
  };
}
