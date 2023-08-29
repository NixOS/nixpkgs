{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tmux-sessionizer";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TTt4pEWlt1cL9SBM6C5dX88MqhBqr4Qt8INnWny8WL4=";
  };

  cargoHash = "sha256-Jq4wpSKo5kq6xSr/qRPlMy9QREUHQ33oQgXrvKi25lM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "The fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
