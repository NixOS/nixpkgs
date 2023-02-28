{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-BTVbx6Fk10A2SayXAH4hRRcUqI6+3VEW25vj3sdApqI=";
  };

  cargoHash = "sha256-eCi8dcaeNjuU7a7W4IJqz9bRbde6PLy/WJCipgancRE=";

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
