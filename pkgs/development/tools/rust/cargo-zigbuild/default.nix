{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.16.11";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1Y/M/xT4Fwn2xJ1XDI82onz5UcGJsivYTXdESx13ehE=";
  };

  cargoSha256 = "sha256-XWNyhwxegy1V+buJz4ffxfF3r2SVcXid8PbKQpljQ2o=";

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
