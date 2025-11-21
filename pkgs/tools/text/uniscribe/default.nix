{
  stdenv,
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  makeWrapper,
}:

let
  rubyEnv = bundlerEnv {
    name = "uniscribe";
    gemdir = ./.;
  };
in
stdenv.mkDerivation {
  pname = "uniscribe";
  version = (import ./gemset.nix).uniscribe.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/uniscribe $out/bin/uniscribe
  '';

  passthru.updateScript = bundlerUpdateScript "uniscribe";

  meta = {
    description = "Explains Unicode characters/code points: Displays their name, category, and shows compositions";
    mainProgram = "uniscribe";
    homepage = "https://github.com/janlelis/uniscribe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kjeremy ];
  };
}
