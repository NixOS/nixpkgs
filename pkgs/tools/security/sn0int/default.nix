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
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LjNOaqYGlhF0U+YxoLLmmXgxPa8f+t9BSm+qO23waaI=";
  };

  cargoSha256 = "sha256-ruK+qDIqrltNcErBnrcHdPfVKmwPwiPfq42A/el206c=";

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
