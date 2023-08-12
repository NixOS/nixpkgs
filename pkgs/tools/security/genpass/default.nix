{ lib
, stdenv
, fetchgit
, rustPlatform
, CoreFoundation
, libiconv
, Security
}:
rustPlatform.buildRustPackage rec {
  pname = "genpass";
  version = "0.5.27";

  src = fetchgit {
    url = "https://git.cyplo.dev/cyplo/genpass.git";
    rev = "v${version}";
    hash = "sha256-XwbAeAeTPILxSV5f76jlpTBfBnX20WK4O1+jYalkKEY=";
  };

  cargoHash = "sha256-93XKQ7KdjCOrfs+6cgOvwYe9FBTxUFbQ0SUJhrpxQC0=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation libiconv Security ];

  meta = with lib; {
    description = "A simple yet robust commandline random password generator";
    homepage = "https://git.cyplo.dev/cyplo/genpass";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ cyplo ];
  };
}
