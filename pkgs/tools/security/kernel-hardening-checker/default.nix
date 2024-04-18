{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "kernel-hardening-checker";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "a13xp0p0v";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xpVazB9G0cdc0GglGpna80EWHZXfTd5mc5mTvvvoPfE=";
  };

  meta = with lib; {
    description = "A tool for checking the security hardening options of the Linux kernel";
    mainProgram = "kernel-hardening-checker";
    homepage = "https://github.com/a13xp0p0v/kernel-hardening-checker";
    changelog = "https://github.com/a13xp0p0v/kernel-hardening-checker/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ julm ];
  };
}
