{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-cqhttp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Mrs4s";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mKenmsGdVg60zjVMTfbEtqtPcJdJo60Nz6IUQ9RB7j0=";
  };

  vendorHash = "sha256-YNARh25xrcPGvhhXzYmg3CsWwzvXq44uWt0S1PjRVdM=";

  meta = with lib; {
    description = "Golang implementation of OneBot based on Mirai and MiraiGo";
    homepage = "https://github.com/Mrs4s/go-cqhttp";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Anillc ];
  };
}
