{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fable";
  version = "4.10.0";

  nugetSha256 = "sha256-qSnPb+qjF10gzP8LSvvqnAXa0tedvOMHCrVd8zTtZl0=";
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Fable is an F# to JavaScript compiler";
    homepage = "https://github.com/fable-compiler/fable";
    changelog = "https://github.com/fable-compiler/fable/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anpin mdarocha ];
  };
}
