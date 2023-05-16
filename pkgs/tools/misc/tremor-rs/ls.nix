{ lib
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
=======
, llvmPackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  nativeBuildInputs = [ rustPlatform.bindgenHook ];
=======
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cargoSha256 = "sha256-/RKwmslhMm30QxviVV7HthDHSmTmaGZn1hdt6bNF3d4=";

  meta = with lib; {
    description = "Tremor Language Server (Trill)";
    homepage = "https://www.tremor.rs/docs/next/getting-started/tooling";
    license = licenses.asl20;
<<<<<<< HEAD
=======
    platforms = platforms.x86_64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ happysalada ];
  };
}
