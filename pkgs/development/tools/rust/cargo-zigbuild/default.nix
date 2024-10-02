{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O3Sg7wVNqTH8uhBSlVpmPNmFv+JC9/tw3G0LcOYUzKc=";
  };

  cargoHash = "sha256-C0TpZZ/CJgNx0sB920/0yJW3iY4tPF6M70bveS1Ux24=";

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
