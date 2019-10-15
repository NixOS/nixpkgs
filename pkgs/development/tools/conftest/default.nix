{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "0blrbbnvnnxyw0idhglqdz16i7g6g86a6kw2iw707bg0yfdl1ncq";
  };

  patches = [
    # Version 0.12.0 does not build with go 1.13. See https://github.com/instrumenta/conftest/pull/85.
    # TODO: Remove once https://github.com/instrumenta/conftest/pull/85 is merged and lands in a release.
    ./go-1.13-deps.patch
  ];

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  modSha256 = "11999ywy73ng45gl1qypky8342jvishcp11bdxbigvqhwl2zbpav";

  meta = with lib; {
    description = "Write tests against structured configuration data";
    homepage = https://github.com/instrumenta/conftest;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
