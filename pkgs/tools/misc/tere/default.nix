{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
  version = "1.5.1_git-ef69b8";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    #rev = "v${version}";
    rev = "ef69b8d9da3a97b73896516ee12680d0edae3053";
    sha256 = "sha256-GkETbDaZ2md3Mzn+GggkuCxd9WAIgRKaoBd1J7az9D8=";
  };

  cargoHash = "sha256-8Hf0gBUFhN6X+/UpBNHrEP5EAFcWrUfIe5EhYQ5Rlno=";

  patches = [
    ./failing-tests.patch
  ];

  postPatch = ''
    rm .cargo/config.toml;
  '';

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
    mainProgram = "tere";
  };
}
