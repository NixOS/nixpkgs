{ lib
, fetchFromGitHub
, rustPlatform
, libsodium
, libseccomp
, sqlite
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "sn0int";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BKdi/o/A0fJBlcKTDTCX7uGkK6QR0S9hIn0DI3CN5Gg=";
  };

  cargoSha256 = "sha256-MeMTXwb5v4iUJQSViOraXAck7n6VlIW2Qa0qNUZWu1g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libsodium
    libseccomp
    sqlite
  ];

  # One of the dependencies (chrootable-https) tries to read "/etc/resolv.conf"
  # in "checkPhase", hence fails in sandbox of "nix".
  doCheck = false;

  meta = with lib; {
    description = "Semi-automatic OSINT framework and package manager";
    homepage = "https://github.com/kpcyrd/sn0int";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
