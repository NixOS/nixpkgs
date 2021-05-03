{ lib, fetchFromGitHub, rustPlatform, libsodium, libseccomp, sqlite, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "sn0int";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vnSpItch9RDUyYxERKRwYPmRLwRG9gAI7iIY+7iRs1w=";
  };

  cargoSha256 = "sha256-1QqNI7rdH5wb1Zge8gkJtzg2Hgd/Vk9DAU9ULk/5wiw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsodium libseccomp sqlite ];

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
