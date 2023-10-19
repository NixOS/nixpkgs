{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-l9uPn5eLGfCq2E6gogXCefbhxro6iOOYraeIPj9/S50=";
  };

  cargoHash = "sha256-2mbGwElBfo4L/iGZm3iRBR5UGeMFlfaSp79vVvCAIo0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  meta = with lib; {
    description = "A tool to compile Cargo projects with zig as the linker";
    homepage = "https://github.com/messense/cargo-zigbuild";
    changelog = "https://github.com/messense/cargo-zigbuild/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
