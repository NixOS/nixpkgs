{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9MmIu7oNdLLOl4zsx/A1v0dEc54bN+J6T2GcLFOvMpQ=";
  };

  cargoSha256 = "sha256-3UNjJRpNrDdrU63R7z+6TJR7lq8waPceDscx2yo+QeE=";

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
