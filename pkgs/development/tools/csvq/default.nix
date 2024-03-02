{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "csvq";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "mithrandie";
    repo = "csvq";
    rev = "v${version}";
    sha256 = "sha256-1UK+LSMKryoUf2UWbGt8MU3zs5hH2WdpA2v/jBaIHYE=";
  };

  vendorHash = "sha256-byBYp+iNnnsAXR+T3XmdwaeeBG8oB1EgNkDabzgUC98=";

  meta = with lib; {
    description = "SQL-like query language for CSV";
    homepage = "https://mithrandie.github.io/csvq/";
    changelog = "https://github.com/mithrandie/csvq/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
