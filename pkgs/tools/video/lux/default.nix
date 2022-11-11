{ lib, buildGoModule, fetchFromGitHub, makeWrapper, ffmpeg }:

buildGoModule rec {
  pname = "lux";
  version = "0.16.0";
  src = fetchFromGitHub {
    owner = "iawia002";
    repo = "lux";
    rev = "v${version}";
    sha256 = "sha256-kB625R6Qlo9sw0iz8MbaCFOjxpMyH+9ugC6JDn7L7eM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "sha256-2cH5xVz3k9PPjzoMjWch3o8VBfP4nWAvakNwZNQLOeI=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    wrapProgram $out/bin/lux \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  doCheck = false;

  meta = with lib; {
    description = "Fast and simple video download library and CLI tool written in Go";
    homepage = "https://github.com/iawia002/lux";
    changelog = "https://github.com/iawia002/lux/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
