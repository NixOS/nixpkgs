{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "litefs";
<<<<<<< HEAD
  version = "0.5.4";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "superfly";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gTXIQVnNyVn2UqigozvEPaPm3XoqHd6E0RZnZS4bP3g=";
  };

  vendorHash = "sha256-4e1tAAXM2EYuqe1AbN1wng/bq1BP7MSOV6woeKjc3x4=";
=======
    sha256 = "sha256-CmWtQzoY/xY/LZL2swhYtDzPvpVOvKlhUH3plDEHrGI=";
  };

  vendorHash = "sha256-1I18ITgFPpUv0mPrt1biJmQV9qd9HB23zJmnDp5WzkA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/litefs" ];

  # following https://github.com/superfly/litefs/blob/main/Dockerfile
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-extldflags=-static"
  ];

  tags = [
    "osusergo"
    "netgo"
    "sqlite_omit_load_extension"
  ];

  doCheck = false; # fails

  meta = with lib; {
    description = "FUSE-based file system for replicating SQLite databases across a cluster of machines";
    homepage = "https://github.com/superfly/litefs";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
