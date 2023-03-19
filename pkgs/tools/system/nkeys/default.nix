{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ePpFzwjFKcm/xgt9TBl1CVnJYxO389rV9uLONeUeX0c=";
  };

  vendorHash = "sha256-ozK0vimYs7wGplw1QhSu+q8R+YsIYHU4m08a7K6i78I=";

  meta = with lib; {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nk";
  };
}
