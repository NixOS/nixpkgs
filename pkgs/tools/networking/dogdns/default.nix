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

  nativeBuildInputs = [ installShellFiles just pandoc ]
    ++ lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  outputs = [ "out" "man" ];

  postBuild = ''
    just man
  '';

  cargoSha256 = "sha256-agepQVJbqbjzFbEBKbM7BNxc8FlklOrCsTgCAOcuptc=";

  postInstall = ''
    installShellCompletion completions/dog.{bash,fish,zsh}
    installManPage ./target/man/*.1
  '';

  meta = with lib; {
    description = "Command-line DNS client";
    homepage = "https://dns.lookup.dog";
    license = licenses.eupl12;
    maintainers = with maintainers; [ bbigras ma27 ];
    mainProgram = "dog";
  };
}
