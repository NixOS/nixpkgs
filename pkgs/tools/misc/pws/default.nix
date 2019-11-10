{ stdenv, lib, bundlerEnv, ruby, bundlerUpdateScript, xsel, makeWrapper }:

let
  env = bundlerEnv {
    name = "${name}-gems";

    inherit ruby;

    gemdir = ./.;
  };
  name = "pws-${(import ./gemset.nix).pws.version}";
in stdenv.mkDerivation rec {
  inherit name;

  buildInputs = [ makeWrapper ];

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/pws $out/bin/pws \
      --set PATH '"${xsel}/bin/:$PATH"'
  '';

  passthru.updateScript = bundlerUpdateScript "pws";

  meta = with lib; {
    description = "Command-line password safe";
    homepage    = https://github.com/janlelis/pws;
    license     = licenses.mit;
    maintainers = with maintainers; [ swistak35 nicknovitski ];
    platforms   = platforms.unix;
  };
}
