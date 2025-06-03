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
    sha256 = lib.fakeSha256;
  };

  postPatch = let
    funcDir = "./functions";
  in /*sh*/
    ''
      substituteInPlace ${funcDir}/_fish_ai_autocomplete.fish \
                        ${funcDir}/_fish_ai_codify.fish \
                        ${funcDir}/_fish_ai_explain.fish \
                        ${funcDir}/_fish_ai_fix.fish \
                        ${funcDir}/fish_ai_switch_context.fish \
                        --replace-fail "~/.fish-ai/bin" "$out/bin"
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
