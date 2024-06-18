{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fscan";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = version;
    hash = "sha256-5uFSvEkTBy0veMdeeg9BmSqu+qSqCwuozK0J3kerAdE=";
  };

  vendorHash = "sha256-FFYqvGEFe7sUEb4G3ApQOuYoiDXeA54P7spmKfRiEF0=";

  meta = with lib; {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = licenses.mit;
    maintainers = with maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
}
