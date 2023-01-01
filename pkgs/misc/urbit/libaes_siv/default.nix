{ stdenv
, lib
, cmake
, openssl
, fetchFromGitHub
}:
stdenv.mkDerivation {
  pname = "libaes_siv";
  version = "9681279cfaa6e6399bb7ca3afbbc27fc2e19df4b";
  src = fetchFromGitHub {
    owner = "dfoxfranke";
    repo = "libaes_siv";
    rev = "9681279cfaa6e6399bb7ca3afbbc27fc2e19df4b";
    sha256 = "1g4wy0m5wpqx7z6nillppkh5zki9fkx9rdw149qcxh7mc5vlszzi";
  };

  patches = [ ./cmakefiles_static.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  meta = {
    description = "An RFC5297-compliant C implementation of AES-SIV";
    homepage = "https://github.com/dfoxfranke/libaes_siv";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.uningan ];
    platforms = lib.platforms.unix;
  };
}
