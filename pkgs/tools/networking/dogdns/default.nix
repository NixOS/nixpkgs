{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, pkg-config
, openssl
, just
, pandoc
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "dogdns";
  version = "unstable-2021-10-07";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "dog";
    rev = "721440b12ef01a812abe5dc6ced69af6e221fad5";
    sha256 = "sha256-y3T0vXg7631FZ4bzcbQjz3Buui/DFxh9LG8BZWwynp0=";
  };

  patches = [
    # remove date info to make the build reproducible
    # remove commit hash to avoid dependency on git and the need to keep `.git`
    ./remove-date-info.patch
  ];

  nativeBuildInputs = [ installShellFiles just pandoc ]
    ++ lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  outputs = [ "out" "man" ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mutagen-0.2.0" = "sha256-FnSeNI9lAcxonRFTu7wnP/M/d5UbMzSZ97w+mUqoEg8=";
    };
  };

  dontUseJustBuild = true;
  dontUseJustCheck = true;
  dontUseJustInstall = true;

  postPatch = ''
    # update Cargo.lock to work with openssl 3
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  postBuild = ''
    just man
  '';

  postInstall = ''
    installShellCompletion completions/dog.{bash,fish,zsh}
    installManPage ./target/man/*.1
  '';

  meta = with lib; {
    description = "Command-line DNS client";
    homepage = "https://dns.lookup.dog";
    license = licenses.eupl12;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "dog";
  };
}
