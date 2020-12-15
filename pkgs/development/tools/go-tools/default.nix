{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2020.2";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "1qqpr481rx6n75xp1racsjjyn2fa8f28pcb0r9kd56qq890h3qgj";
  };

  vendorSha256 = "1axci0l7pymy66j6lilm49ksrwp7dvnj5krai2kvy96n3arcnsvq";

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
