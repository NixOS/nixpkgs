{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fable";
  version = "4.5.0";

  nugetSha256 = "sha256-KeNkS2fuZFnI8WVqSpIRjo2eA+XKuHLLpMIzDzgqXdg=";

  meta = with lib; {
    description = "Fable is an F# to JavaScript compiler";
    homepage = "https://github.com/fable-compiler/fable";
    changelog = "https://github.com/fable-compiler/fable/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anpin mdarocha ];
  };
}
