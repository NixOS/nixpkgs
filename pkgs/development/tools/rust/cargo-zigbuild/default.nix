{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  zig,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AY5oq8fSF1IEvmbB5hRjo+Esz7EE9ZI4EKwtZIjbasA=";
  };

  cargoHash = "sha256-StYEw5DvgxEojRcF0g88CTa58qUDjgNJiw6BCYKNzBY=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  meta = with lib; {
    description = "Tool to compile Cargo projects with zig as the linker";
    mainProgram = "cargo-zigbuild";
    homepage = "https://github.com/messense/cargo-zigbuild";
    changelog = "https://github.com/messense/cargo-zigbuild/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
