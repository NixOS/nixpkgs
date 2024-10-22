{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9rjrNxMUUuH3S6fVsooscgIP+oFeQ6/gBQmuUMPDfp0=";
  };

  cargoHash = "sha256-/0jviI91y4eAJ0uZDQqnw9htcl+j0aybY0U5gCc9DFg=";

  meta = with lib; {
    description = "High performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
