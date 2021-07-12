{ lib
, fetchgit
, rustPlatform
, unzip
, rsync
, innoextract
, curl
, cmake
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "wyvern";
  version = "1.4.1";

  src = fetchgit {
    url = "https://git.sr.ht/~nicohman/wyvern";
    rev = version;
    sha256 = "1sl3yhash1527amc8rs4374fd7jbgnkyy7qpw94ms2gs80sdv3s5";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "sha256:1nd5qla3p1jrssg5fqal8m3jcbxax0wsfc8cp97jdrpqlcgqfmrx";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A simple CLI client for installing and maintaining linux GOG games";
    homepage = "https://git.sr.ht/~nicohman/wyvern";
    license = licenses.gpl3;
    maintainers = with maintainers;[ _0x4A6F ];
    platforms = platforms.linux;
  };
}
