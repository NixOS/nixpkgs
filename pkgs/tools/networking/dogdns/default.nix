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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "dog";
    rev = "v${version}";
    sha256 = "sha256-/qefunr1mozOIPdVJlq39+x02C+ub4ftzhtsZjVYESE=";
  };

  nativeBuildInputs = [ installShellFiles just pandoc ]
    ++ lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  outputs = [ "out" "man" ];

  postBuild = ''
    just man
  '';

  cargoSha256 = "sha256-KwP1Un1VNr3zKvwLAq+IXXNY6m2mNgqrp8j/AQZW/30=";

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
