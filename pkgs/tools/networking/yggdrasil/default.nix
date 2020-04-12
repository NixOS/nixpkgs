{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yggdrasil";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "1h1xqg144adbgsiz00hjzxslakwfp3c5y8myczqq8nv46m29v110";
  };

  modSha256 = "1ywjan4hzkrmkqhwmlizhyz314rxcv50jzb4mhy5xaiszav59q8i";

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
    description =
      "An experiment in scalable routing as an encrypted IPv6 overlay network";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ gazally lassulus ehmry ];
  };
}
