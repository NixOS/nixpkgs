{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix
, nlohmann_json
, boost
, graphviz
, Security
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "sha256-HfmMZVlsdg9hTWGUihl6OlQAp/n1XRvPLfAKJ8as8Ew=";
  };

  cargoSha256 = "sha256-oUxxuBqec4aI2h8BAn1WSA44UU7f5APkv0DIwuSun0M=";

  doCheck = true;
  nativeCheckInputs = [ nix graphviz ];

  buildInputs = [
    boost
    nix
    nlohmann_json
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  meta = with lib; {
    description = "Tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
    mainProgram = "nix-du";
  };
}
