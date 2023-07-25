{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fable";
  version = "4.1.4";

  nugetSha256 = "sha256-9wMQj4+xmAprt80slet2wUW93fRyEhOhhNVGYbWGS3Y=";

  meta = with lib; {
    description = "Fable is an F# to JavaScript compiler";
    homepage = "https://github.com/fable-compiler/fable";
    changelog = "https://github.com/fable-compiler/fable/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anpin mdarocha ];
  };
}
