{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "renderizer";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "gomatic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ji+wTTXLp17EYRIjUiVgd33ZeBdT8K2O8R2Ejq2Ll5I=";
  };

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version} -X main.commitHash=${src.rev} -X main.date=19700101T000000"
  ];

  vendorSha256 = null;

  meta = with lib; {
    description = "CLI to render Go template text files";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ yurrriq ];
  };
}
