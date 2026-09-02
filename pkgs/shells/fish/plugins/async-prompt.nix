{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin (finalAttrs: {
  pname = "async-prompt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "acomagu";
    repo = "fish-async-prompt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HWW9191RP//48HkAHOZ7kAAAPSBKZ+BW2FfCZB36Y+g=";
  };

  meta = {
    description = "Make your prompt asynchronous to improve the reactivity";
    homepage = "https://github.com/acomagu/fish-async-prompt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      samasaur
    ];
  };
})
