{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:
rustPlatform.buildRustPackage {
  pname = "rblake2sum";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "rblake2sum";
    rev = "cdbaba9f198bd28bfad2fbc17011ce5c8c7ad957";
    hash = "sha256-bzOjJ+/M0YWY4/r8cNARPVqbuLBeTllqFyVXhJz6ZMI=";
  };

  cargoHash = "sha256-egwL3z7uB4AcRwPT0uPrenyh4FSxhbZKMdkPhRztMbs=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A recursive blake2 digest (hash) of a file-system path";
    homepage = "https://github.com/crev-dev/rblake2sum";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ dpc ];
  };
}
