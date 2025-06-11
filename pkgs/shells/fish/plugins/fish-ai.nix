{
  lib,
  pkgs,
  stdenv,
  #buildFishPlugin,
  fetchFromGitHub,
  writeScript,
  wrapFish,
}:
  let
    buildFishPlugin = import ./build-fish-plugin.nix {inherit stdenv lib writeScript wrapFish; };
  in
    buildFishPlugin rec {
      pname = "fish-ai";
      version = "1.8.0";

      src =
        fetchFromGitHub
          {
            owner = "Realiserad";
            repo = pname;
            rev = "v1.8.0";
            sha256 = lib.fakeSha256;
          };

      runtimeDependencies =
        with pkgs;
          [
            git
            python3
            python3Packages.pip
          ];

      postPatch = # REMOVE HARDCODED ~/.fish-ai/bin SO WE CAN USE NIX STORE
        let
          fDir = "./functions";
        in /*sh*/
          ''
            substituteInPlace ${fDir}/_fish_ai_autocomplete.fish \
                              ${fDir}/_fish_ai_codify.fish \
                              ${fDir}/_fish_ai_explain.fish \
                              ${fDir}/_fish_ai_fix.fish \
                              ${fDir}/fish_ai_switch_context.fish \
                              --replace-fail "~/.fish-ai/bin" $out/share/fish/vendor_functions.d
          '';

      postInstall =  #buildFishplugin DOESN'T COPY PYTHON .py FILES, ONLY .fish
        ''
          cp -r src/fish-ai/* $out/share/fish/vendor_functions.d
        '';

      nativeCheckInputs = [ pkgs.python3 ];
      checkPhase =
        ''
          make test
        '';

      meta =
        with lib;
          {
            description = " Supercharge your command line with LLMs and get shell scripting assistance in Fish. 💪";
            homepage = "https://github.com/Realiserad/fish-ai";
            license = licenses.mit;
            maintainers = with maintainers; [ bndlfm ];
          };
    }
