{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "qdrant";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-rOIWiSpAqIUf2V9BMMTZqF/urz754pZV4yHav26dxqY=";
  };

  cargoSha256 = "sha256-ovHxtOYlzVsALw/4bhL9EcFXaKr6Bg/D0w6OPMCLZoQ=";

  nativeBuildInputs = [ protobuf rustPlatform.bindgenHook ];

  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin "-faligned-allocation";

  meta = with lib; {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
