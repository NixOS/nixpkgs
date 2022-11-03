{ lib
, buildGoModule
, fetchFromGitHub
, updateGolangSysHook
}:
buildGoModule {
  pname = "earlybird";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "americanexpress";
    repo = "earlybird";
    # According to the GitHub repo, the latest version *is* 1.25.0, but they
    # tagged it as "refs/heads/main-2"
    rev = "4f365f1c02972dc0a68a196a262912d9c4325b21";
    sha256 = "UZXHYBwBmb9J1HrE/htPZcKvZ+7mc+oXnUtzgBmBgN4=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-bRCzlq+hlzLmrzCdHHtXYRFVDpDgEN6Hlt/gCr2Pfig=";

  meta = with lib; {
    description = "A sensitive data detection tool capable of scanning source code repositories for passwords, key files, and more";
    homepage = "https://github.com/americanexpress/earlybird";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
