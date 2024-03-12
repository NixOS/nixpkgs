{ expect, fetchFromGitHub, lib, rustPlatform, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "fcp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "svetlitski";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f242n8w88rikg1srimdifadhggrb2r1z0g65id60ahb4bjm8a0x";
  };

  cargoSha256 = "0gw7gjfwc4r03rg6z65ml0y37sh4yf716isqs0mb4jqkp7rwfbc9";

  nativeBuildInputs = [ expect ];

  # character_device fails with "File name too long" on darwin
  doCheck = !stdenv.isDarwin;

  postPatch = ''
    patchShebangs tests/*.exp
  '';

  meta = with lib; {
    description = "A significantly faster alternative to the classic Unix cp(1) command";
    homepage = "https://github.com/svetlitski/fcp";
    changelog = "https://github.com/svetlitski/fcp/releases/tag/v${version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fcp";
  };
}
