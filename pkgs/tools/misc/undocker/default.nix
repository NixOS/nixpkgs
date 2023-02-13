{ lib
, buildGoModule
, fetchFromSourcehut
}:
buildGoModule rec {
  pname = "undocker";
  version = "1.0.3";

  src = fetchFromSourcehut {
    owner = "~motiejus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SmtM25sijcm5NF0ZrSqrRQDXiLMNp8WGAZX9yKvj1rQ=";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://git.sr.ht/~motiejus/undocker";
    description = "A CLI tool to convert a Docker image to a flattened rootfs tarball";
    license = licenses.mit;
    maintainers = with maintainers; [ jordanisaacs ];
  };
}
