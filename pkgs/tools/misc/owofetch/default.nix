{ lib
, stdenvNoCC
, rustPlatform
, fetchFromGitHub
, Foundation
, DiskArbitration
}:

rustPlatform.buildRustPackage rec {
  pname = "owofetch";

  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "netthier";
    repo = "owofetch-rs";
    rev = "v${version}";
    sha256 = "sha256-I8mzOUvm72KLLBumpgn9gNyx9FKvUrB4ze1iM1+OA18=";
  };

  cargoSha256 = "sha256-rfN4QERs1H1G7ZZim//78vlxbYfU4Cx7SYYUz/QLKeU=";

  buildInputs = lib.optionals stdenvNoCC.isDarwin [
    Foundation
    DiskArbitration
  ];

  meta = with lib; {
    description = "Alternative to *fetch, uwuifies all stats";
    homepage = "https://github.com/netthier/owofetch-rs";
    license = licenses.gpl3Only;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ nullishamy ];
  };
}
