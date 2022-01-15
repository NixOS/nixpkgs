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
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AP/3QCol2qOvRqNW9F/m9JpiZrqtfXvr//Ku2XE3vqY=";
  };

  cargoSha256 = "sha256-gdDQjYU8hJdkQCh1Iswn5KlPW2BT/J5vCSOS/KHvbH4=";

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
