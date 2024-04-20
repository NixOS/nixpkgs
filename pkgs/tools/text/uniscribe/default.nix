{ stdenv, lib, bundlerEnv, bundlerUpdateScript, makeWrapper }:

let
  rubyEnv = bundlerEnv {
    name = "uniscribe";
    gemdir = ./.;
  };
in
stdenv.mkDerivation rec {
  pname = "uniscribe";
  version = (import ./gemset.nix).uniscribe.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/uniscribe $out/bin/uniscribe
  '';

  passthru.updateScript = bundlerUpdateScript "uniscribe";

  meta = with lib; {
    description = "Explains Unicode characters/code points: Displays their name, category, and shows compositions";
    mainProgram = "uniscribe";
    homepage = "https://github.com/janlelis/uniscribe";
    license = licenses.mit;
    maintainers = with maintainers; [ kjeremy ];
  };
}
