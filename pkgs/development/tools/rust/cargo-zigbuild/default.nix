{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qwOlYy9pNAKEJDgt3ML4dxDwlkyPIVO+X/q/YijEHo0=";
  };

  cargoSha256 = "sha256-8x2B8WBN9u17HS58bAwMNPEoSabNX6KzyPBLEvaGOBk=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  meta = with lib; {
    description = "A tool to compile Cargo projects with zig as the linker";
    homepage = "https://github.com/messense/cargo-zigbuild";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
