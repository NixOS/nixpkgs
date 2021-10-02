{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, stdenv
, libiconv
, CoreFoundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DUFJZEtJM5Sv41zJvSZ8KsNWFzlictM2T1wS7VxPL04=";
  };

  cargoSha256 = "sha256-kubQL+p7J2koPDOje5wMxKDeCY4yi0kupfHsJCKYf44=";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv CoreFoundation Security ];

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
