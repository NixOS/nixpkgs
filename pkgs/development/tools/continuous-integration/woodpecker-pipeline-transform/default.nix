{
  lib,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule rec {
  pname = "woodpecker-pipeline-transform";
  version = "0.1.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lafriks";
    repo = "woodpecker-pipeline-transform";
    rev = "v${version}";
    sha256 = "sha256-tWDMbOkajZ3BB32Vl630EZrY+Owm72MD2Z2JjMucVkI=";
  };

  vendorHash = "sha256-qKzGALMagf6QHeLdABfNGG4f/3K/F6CjVYjOJtyTNoM=";

  meta = with lib; {
    description = "Utility to convert different pipelines to Woodpecker CI pipelines";
    homepage = "https://codeberg.org/lafriks/woodpecker-pipeline-transform";
    license = licenses.mit;
    mainProgram = "pipeline-convert";
    maintainers = with maintainers; [ ambroisie ];
  };
}
