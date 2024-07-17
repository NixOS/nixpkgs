{
  lib,
  buildGoModule,
  fetchFromGitea,
  gnumake,
}:
let
  version = "1.2.2";
  hash = "sha256-kBqNopcHpldU5oD6zoVjPjP84t12QFcbWBSNNgwImKg=";
  src = fetchFromGitea {
    domain = "git.jakstys.lt";
    owner = "motiejus";
    repo = "undocker";
    rev = "v${version}";
    hash = hash;
  };
in
buildGoModule {
  pname = "undocker";
  inherit version src;

  nativeBuildInputs = [ gnumake ];

  buildPhase = "make VSN=v${version} VSNHASH=${hash} undocker";

  installPhase = "install -D undocker $out/bin/undocker";

  vendorHash = null;

  meta = with lib; {
    homepage = "https://git.jakstys.lt/motiejus/undocker";
    description = "CLI tool to convert a Docker image to a flattened rootfs tarball";
    license = licenses.asl20;
    maintainers = with maintainers; [
      jordanisaacs
      motiejus
    ];
    mainProgram = "undocker";
  };
}
