{ lib
, buildGoModule
, fetchFromSourcehut
}:
buildGoModule rec {
  pname = "undocker";
  version = "1.0.4";

  src = fetchFromSourcehut {
    owner = "~motiejus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I+pTbr1lKELyYlyHrx2gB+aeZ3/PmcePQfXu1ckhKAk=";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://git.sr.ht/~motiejus/undocker";
    description = "A CLI tool to convert a Docker image to a flattened rootfs tarball";
    license = licenses.asl20;
    maintainers = with maintainers; [ jordanisaacs ];
  };
}
