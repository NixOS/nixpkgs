{ lib, buildGoModule, fetchFromGitHub, makeWrapper, ffmpeg }:

buildGoModule rec {
  pname = "lux";
  version = "0.17.0";
  src = fetchFromGitHub {
    owner = "iawia002";
    repo = "lux";
    rev = "v${version}";
    sha256 = "sha256-n6oWItz0tnhpyPBGsf4+fYGnJyeYyhI2owkLrJWu7uw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-4pn6JKE+VieadhDLkVhbJc6XSm95cNwoNBWYGEZl8iI=";

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
