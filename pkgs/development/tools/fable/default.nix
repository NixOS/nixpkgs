{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fable";
  version = "4.13.0";

  nugetSha256 = "sha256-jjvAAhnCkCBLG2sq3ehCTdg/thaVW7A7nXyVCSAGm3k=";
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Fable is an F# to JavaScript compiler";
    mainProgram = "fable";
    homepage = "https://github.com/fable-compiler/fable";
    changelog = "https://github.com/fable-compiler/fable/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      anpin
      mdarocha
    ];
  };
}
