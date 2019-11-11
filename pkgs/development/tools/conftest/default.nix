{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "0fjz6ad8rnznlp1kiyb3c6anhjs6v6acgziw4hmyz0xva4jnspsh";
  };

  modSha256 = "1xwqlqx5794hsi14h5gqg69gjcqcma24ha0fxn0vffqgqs2cz1d1";

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  subPackages = [ "cmd" ];

  meta = with lib; {
    description = "Write tests against structured configuration data";
    homepage = https://github.com/instrumenta/conftest;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
