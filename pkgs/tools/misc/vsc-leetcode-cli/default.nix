{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage {
  pname = "vsc-leetcode-cli";
  version = "unstable-2021-04-11";

  src = fetchFromGitHub {
    owner = "leetcode-tools";
    repo = "leetcode-cli";
    rev = "c5f6b8987185ae9f181e138f999825516240f44c";
    hash = "sha256-N8hQqIzCUYTT5RAd0eqNynSNkGiN4omFY+8QLBemIbs=";
  };

  npmDepsHash = "sha256-t8eEnyAKeDmbmduUXuxo/WbJTced5dLeJTbtjxrrxY8=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "A CLI tool for leetcode.com";
    homepage = "https://github.com/leetcode-tools/leetcode-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "leetcode";
  };
}
