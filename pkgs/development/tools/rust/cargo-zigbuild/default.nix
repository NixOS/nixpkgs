{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lYQmuenL7cbgfb6tdhdxkNe3wrQj7hTijyrhr/p4zLo=";
  };

  cargoSha256 = "sha256-Ae0ootHGbW5FJTkIRc9lTKHWsHOz6/WZCWCLZlSROU4=";

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
