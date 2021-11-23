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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BP1B1FlN+9qpkqv4WfT7OSyPCb7K47uxJQKXAW1Kkck=";
  };

  cargoSha256 = "sha256-Lp0VGt6z9mE8b9Fi6Fz3MjmHmbr9Az72D7BzOju9uOI=";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation Security ];

  # link System as a dylib instead of a framework on macos
  postPatch = lib.optionalString stdenv.isDarwin ''
    core_affinity=../$(stripHash $cargoDeps)/core_affinity
    oldHash=$(sha256sum $core_affinity/src/lib.rs | cut -d " " -f 1)
    substituteInPlace $core_affinity/src/lib.rs --replace framework dylib
    substituteInPlace $core_affinity/.cargo-checksum.json \
      --replace $oldHash $(sha256sum $core_affinity/src/lib.rs | cut -d " " -f 1)
  '';

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
