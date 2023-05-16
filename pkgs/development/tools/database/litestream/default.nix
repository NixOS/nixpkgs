{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "litestream";
<<<<<<< HEAD
  version = "0.3.11";
=======
  version = "0.3.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-03gGGx8RZEK2RrToN30gkIlHss/e3UcSi3AmMh9twDU=";
=======
    sha256 = "sha256-zs+Li8ylw+zexxuEkXX4qk7qslk23BLBcoHXRIuQNmU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-sYIY3Z3VrCqbjEbQtEY7q6Jljg8jMoa2qWEB/IkDjzM=";
=======
  vendorSha256 = "sha256-GiCvifdbWz+hH6aHACzlBpppNC5p24MHRWlbtKLIFhE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Streaming replication for SQLite";
    license = licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with maintainers; [ fbrs ];
  };
}
