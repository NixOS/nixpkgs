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
  pname = "crabz";
  version = "0.7.10";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A1mjnGnFKgCdwr2J0MBUzpL/UI9nOHDxbrZ9UazqZik=";
  };

  cargoSha256 = "sha256-YxO0YPY82Q6dXOBs2ZoSAv14p67kNsmhGOiwt+voD5I=";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    CoreFoundation
    Security
  ];

  # link System as a dylib instead of a framework on macos
  postPatch = lib.optionalString stdenv.isDarwin ''
    core_affinity=../$(stripHash $cargoDeps)/core_affinity
    oldHash=$(sha256sum $core_affinity/src/lib.rs | cut -d " " -f 1)
    substituteInPlace $core_affinity/src/lib.rs --replace framework dylib
    substituteInPlace $core_affinity/.cargo-checksum.json \
      --replace $oldHash $(sha256sum $core_affinity/src/lib.rs | cut -d " " -f 1)
  '';

  meta = with lib; {
    description = "A cross platform, fast, compression and decompression tool";
    homepage = "https://github.com/sstadick/crabz";
    changelog = "https://github.com/sstadick/crabz/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
