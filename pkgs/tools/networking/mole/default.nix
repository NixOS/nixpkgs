{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "mole";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "davrodpin";
    repo = pname;
    rev = "v${version}";
    sha256 = "11q48wfsr35xf2gmvh4biq4hlpba3fh6lrm3p9wni0rl1nxy40i7";
  };

  vendorSha256 = "1qm328ldkaifj1vsrz025vsa2wqzii9rky00b6wh8jf31f4ljbzv";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/davrodpin/mole/cmd.version=${version}"
  ];

  meta = with lib; {
    description = "CLI application to create SSH tunnels";
    homepage = "https://github.com/davrodpin/mole";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin; # build fails with go > 1.17
  };
}
