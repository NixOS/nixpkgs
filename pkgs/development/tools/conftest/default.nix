{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "0qq2kp9h91rirlhml5vyzmi7rd4v3pkqjk2bn7mvdn578jnwww24";
  };

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  modSha256 = "0c9phka7n2cfi8lf0a3prks2pjna5dgf5lj6az82iklnq4p7177y";

  meta = with lib; {
    description = "Write tests against structured configuration data";
    homepage = https://github.com/instrumenta/conftest;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
