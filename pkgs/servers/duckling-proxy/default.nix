{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "duckling-proxy";
  version = "2021-07-23-unstable";

  src = fetchFromGitHub {
    owner = "LukeEmmet";
    repo = "duckling-proxy";
    rev = "e2bfd73a60d7afa43f13a9d420d514131fee8fd1";
    hash = "sha256-GRIJwHrPg0NCNOOj/hTNmmn1ceUEmSLDD0sXR5SzkIw=";
  };

  vendorHash = "sha256-zmOtwx2+mBHDua9Z+G+MnxWaBzoqBPymwEcl+4oKs3M=";

  meta = with lib; {
    description = "Gemini proxy to access the Small Web";
    homepage = "https://github.com/LukeEmmet/duckling-proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
