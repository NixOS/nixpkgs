{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    rev = "refs/tags/v${version}";
    hash = "sha256-hLjiY4+01t1ZlP+N8qBG0YiDiw6VdTdeNkrwHwthrjk=";
  };

  vendorHash = "sha256-T6VcyklwfRS012ZRzqxkahn9YYrQGky/znTqLIkAoK0=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
