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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "sha256-2OODk0Z6UpUOHrGOrMa0XZnG/CPP4yfP8kvsE9Mn3DU=";
  };

  cargoSha256 = "sha256-LB2XJSANQOKHlbifPMd8hH26bRO06Vp+qjWomvrU8Dc=";

  doCheck = true;
  checkInputs = [ nix graphviz ];

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
