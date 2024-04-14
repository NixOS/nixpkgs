{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xg5jSA3J6QzqiItNV+poVxxXmKKPE7TsEYMGdKv4k+k=";
  };

  cargoHash = "sha256-ZXETP60R2121xTFqsvIFziUtKhL+ODGCpG98Mlt/zlg=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
