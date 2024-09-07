{ stdenv, lib, bundlerEnv, bundlerUpdateScript, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "reckon";
  version = (import ./gemset.nix).reckon.version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = let
    env = bundlerEnv {
      name = "${pname}-${version}-gems";

      gemdir = ./.;
    };
  in ''
    runHook preInstall
    mkdir -p $out/bin
    makeWrapper ${env}/bin/reckon $out/bin/reckon
    runHook postInstall
  '';

  passthru.updateScript = bundlerUpdateScript "reckon";

  meta = with lib; {
    description = "Flexibly import bank account CSV files into Ledger for command line accounting";
    mainProgram = "reckon";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.unix;
    changelog = "https://github.com/cantino/reckon/blob/v${version}/CHANGELOG.md";
  };
}
