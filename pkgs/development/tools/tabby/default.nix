{ lib
, fetchFromGitHub
, cmake
, git
, openssl
, pkg-config
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  version = "0.6.0";
  pname = "tabby";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cZvfJMFsf7m8o5YKpsJpcrRmxJCQOFxrDzJZXMzVeFA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-iv8MpBfGGUFkjUZ9eAGq65vCy62VJQGTYIS0r9GRyfo=";

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config protobuf git cmake ];

  buildInputs = [ openssl ];

  # Fails with:
  # file cannot create directory: /var/empty/local/lib64/cmake/Llama
  doCheck = false;

  meta = with lib; {
    description = "Self-hosted AI coding assistant";
    mainProgram = "tabby";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
