{
  buildDotnetGlobalTool,
  lib,
  testers,
}:

buildDotnetGlobalTool (finalAttrs: {
  pname = "fable";
  version = "4.24.0";

  nugetHash = "sha256-ERewWqfEyyZKpHFFALpMGJT0fDWywBYY5buU/wTZZTg=";

  passthru.tests = testers.testVersion {
    package = finalAttrs.finalPackage;
    # the version is written with an escape sequence for colour, and I couldn't
    # find a way to disable it
    version = "[37m${finalAttrs.version}";
  };

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
})
