{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yggdrasil";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "0cz9axphqvpqwy591ws9by7khpdw96iwf9vmhif3i52ghp8hpfd1";
  };

  modSha256 = "1vqk0jyqc1qcryi247r5pbvfjw3m48l028fb2mrq1xqqfkjqrr85";

  # Change the default location of the management socket on Linux
  # systems so that the yggdrasil system service unit does not have to
  # be granted write permission to /run.
  patches = [ ./change-runtime-dir.patch ];

  subPackages = [ "cmd/yggdrasil" "cmd/yggdrasilctl" ];

  buildFlagsArray = ''
    -ldflags=
      -X github.com/yggdrasil-network/yggdrasil-go/src/version.buildVersion=${version}
      -X github.com/yggdrasil-network/yggdrasil-go/src/version.buildName=${pname}
      -s -w
  '';

  meta = with lib; {
    description = "An experiment in scalable routing as an encrypted IPv6 overlay network";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ gazally lassulus ];
  };
}
