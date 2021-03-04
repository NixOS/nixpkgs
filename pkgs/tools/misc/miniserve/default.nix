{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "sha256-/vtiHRHsbF7lfn9tfgfKhm5YwofjSJniNNnKahphHFg=";
  };

  cargoSha256 = "sha256-gwy/LeVznZyawliXnkULyyVSXATk0sjSTUZPHO2K+9o=";

  nativeBuildInputs = [ pkg-config zlib ];
  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zowoq ];
    platforms = platforms.unix;
  };
}
