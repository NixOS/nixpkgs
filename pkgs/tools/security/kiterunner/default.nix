{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kiterunner";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "assetnote";
    repo = pname;
    rev = "v${version}";
    sha256 = "084jywgqjj2hpaprdcb9a7i8hihphnfil0sx3wrlvjpa8sk0z1mw";
  };

  vendorSha256 = "1nczzzsnh38qi949ki5268y39ggkwncanc1pv7727qpwllzl62vy";

  ldflags = [
    "-s" "-w" "-X github.com/assetnote/kiterunner/cmd/kiterunner/cmd.Version=${version}"
  ];

  subPackages = [ "./cmd/kiterunner" ];

  # Test data is missing in the repo
  doCheck = false;

  meta = with lib; {
    description = "Contextual content discovery tool";
    longDescription = ''
      Kiterunner is a tool that is capable of not only performing traditional
      content discovery at lightning fast speeds, but also bruteforcing routes
      and endpoints in modern applications.
    '';
    homepage = "https://github.com/assetnote/kiterunner";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
