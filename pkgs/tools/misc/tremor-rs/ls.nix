{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "tremor-language-server";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-language-server";
    rev = "v${version}";
    sha256 = "sha256-odYhpb3FkbIF1dc2DSpz3Lg+r39lhDKml9KGmbqJAtA=";
  };

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  cargoSha256 = "sha256-/RKwmslhMm30QxviVV7HthDHSmTmaGZn1hdt6bNF3d4=";

  meta = with lib; {
    description = "Tremor Language Server (Trill)";
    homepage = "https://www.tremor.rs/docs/next/getting-started/tooling";
    license = licenses.asl20;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ happysalada ];
  };
}
