{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "htmlhint";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "htmlhint";
    repo = "HTMLHint";
    rev = "v${version}";
    hash = "sha256-6R+/uwqWpuTjUnFeUFMzZBzhlFBxYceYZfLLuaYhc6k=";
  };

  npmDepsHash = "sha256-m5hHxA2YTk7qNpc1Z6TXxNTfIMY5LCM9Il9JHJxQJlI=";

  meta = {
    changelog = "https://github.com/htmlhint/HTMLHint/blob/${src.rev}/CHANGELOG.md";
    description = "Static code analysis tool for HTML";
    homepage = "https://github.com/htmlhint/HTMLHint";
    license = lib.licenses.mit;
    mainProgram = "htmlhint";
    maintainers = with lib.maintainers; [ ];
  };
}
