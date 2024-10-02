{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tunnelto";
  version = "unstable-2022-09-25";

  src = fetchFromGitHub {
    owner = "agrinman";
    repo = pname;
    rev = "06428f13c638180dd349a4c42a17b569ab51a25f";
    sha256 = "sha256-84jGcR/E1QoqIlbGu67muYUtZU66ZJtj4tdZvmYbII4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libhoney-rust-0.1.6" = "sha256-orKQ+MNHF1VSo74XahY9NFf5qMm0Wj95y6nbaG3Ivog=";
      "tracing-distributed-0.3.1" = "sha256-i+2wqIp1BFmHEnd56Wp49LzEkTR9k5xgru1UIjj3Qys=";
    };
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    description = "Expose your local web server to the internet with a public URL";
    homepage = "https://tunnelto.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
