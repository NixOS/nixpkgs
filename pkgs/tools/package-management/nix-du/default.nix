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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "sha256-JU0kXMS4vCMdm3nOJM92Bit16141iuBnjRaV+HXiReQ=";
  };

  cargoSha256 = "sha256-DX0jpp1ujaeesW7iQWZ5/xAzGndOQqBmQZbBpMEI9u0=";

  doCheck = true;
  nativeCheckInputs = [ nix graphviz ];

  buildInputs = [
    boost
    nix
    nlohmann_json
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  meta = with lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
