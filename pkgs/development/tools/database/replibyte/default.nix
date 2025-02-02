{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "replibyte";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VExA92g+1y65skxLKU62ZPUPOwdm9N73Ne9xW7Q0Sic=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mongodb-schema-parser-0.5.0" = "sha256-P3srDY4bEDDYyic7Am2Cg+75j/kETf0uC7ui61TUJQA=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  cargoBuildFlags = [ "--all-features" ];

  doCheck = false; # requires multiple dbs to be installed

  meta = with lib; {
    description = "Seed your development database with real data";
    mainProgram = "replibyte";
    homepage = "https://github.com/Qovery/replibyte";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
