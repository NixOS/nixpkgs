{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, stdenv
, CoreFoundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m4YVz3kh4nOkdf6PbbyxjKacUVKdFQet76CMrFYMRHI=";
  };

  cargoSha256 = "sha256-4z1kHSev+5+0wpYFEGvvafB50Wz1wr6zObCjvHR9FPU=";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation Security ];

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
