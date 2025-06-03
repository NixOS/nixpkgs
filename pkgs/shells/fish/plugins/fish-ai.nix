{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  python3,
}:

buildFishPlugin rec {
  pname = "fish-ai";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Realiserad";
    repo = pname;
    rev = "v1.8.0";
    sha256 = "";
  };

  postPatch = let
    pyPlug= "./src/fish-ai";
    fshFunc = "./functions";
  in /*sh*/
    ''
      substituteInPlace ${fshFunc}/_fish_ai_autocomplete.fish \
                        ${fshFunc}/_fish_ai_codify.fish \
                        ${fshFunc}/_fish_ai_explain.fish \
                        ${fshFunc}/_fish_ai_fix.fish \
                        ${fshFunc}/fish_ai_switch_context.fish \
                        --replace-fail "~/.fish-ai/bin" $out/bin
    '';

  #buildFishplugin will only move the .fish files, but bass also relies on python
  postInstall = ''
    cp -r src/fish-ai/* $out/bin
  '';

  nativeCheckInputs = [ python3 ];
  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description = " Supercharge your command line with LLMs and get shell scripting assistance in Fish. 💪";
    homepage = "https://github.com/Realiserad/fish-ai";
    license = licenses.mit;
    maintainers = with maintainers; [ bndlfm ];
  };
}
