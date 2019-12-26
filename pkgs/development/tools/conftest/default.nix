{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "0lb644fj80r4igxbslbd5pksirnyf6slz4yn0mznyx8i2bd1g4ic";
  };

  modSha256 = "1p7fjg1vcrcxb4f5hd00qxx4fqcl051klcjs6ljn4v46qcpn6dcn";

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    homepage = https://github.com/instrumenta/conftest;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
