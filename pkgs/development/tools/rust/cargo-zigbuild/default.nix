{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
<<<<<<< HEAD
  version = "0.17.3";
=======
  version = "0.16.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-l9uPn5eLGfCq2E6gogXCefbhxro6iOOYraeIPj9/S50=";
  };

  cargoHash = "sha256-2mbGwElBfo4L/iGZm3iRBR5UGeMFlfaSp79vVvCAIo0=";
=======
    sha256 = "sha256-XMlmggT0L9F3J8/WA6AUZTnpCzyZTtb7feKDabPvW/Y=";
  };

  cargoSha256 = "sha256-OLMKvB7l29vM/n59dklyEXT5DXvImYKc3EdwnPVY968=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
