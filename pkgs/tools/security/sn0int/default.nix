{ lib, fetchFromGitHub, rustPlatform,
  libsodium, libseccomp, sqlite, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "sn0int";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b21b0ryq03zrhqailg2iajirn30l358aj3k44lfnravr4h9zwkj";
  };

  cargoSha256 = "1pvn0sc325b5fh29m2l6cack4qfssa4lp3zhyb1qzkb3fmw3lgcy";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libsodium libseccomp sqlite ];

  # One of the dependencies (chrootable-https) tries to read "/etc/resolv.conf"
  # in "checkPhase", hence fails in sandbox of "nix".
  doCheck = false;

  meta = with lib; {
    description = "Semi-automatic OSINT framework and package manager";
    homepage = "https://github.com/kpcyrd/sn0int";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
