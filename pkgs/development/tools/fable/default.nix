{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fable";
  version = "4.20.0";

  nugetHash = "sha256-K3908gEbl9crT4wmZfBtvag5Z6qYABfalBfLZlqZuDk=";
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Fable is an F# to JavaScript compiler";
    mainProgram = "fable";
    homepage = "https://github.com/fable-compiler/fable";
    changelog = "https://github.com/fable-compiler/fable/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anpin mdarocha ];
  };
}
