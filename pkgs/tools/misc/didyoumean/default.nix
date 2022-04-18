{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libxcb
# Darwin dependencies
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "didyoumean";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hisbaan";
    repo = "didyoumean";
    rev = "v${version}";
    sha256 = "sha256-t2bmvz05vWIxQhC474q/9uky1kAQoFN8Z+qflw5Vj68=";
  };

  cargoSha256 = "sha256-4DbziI9enib4pm9/P4WEu15glIxtejaV2GCqbzuxxyw=";

  buildInputs = lib.optional stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "A CLI spelling corrector for when you're unsure";
    homepage = "https://github.com/hisbaan/didyoumean";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ evanjs ];
  };
}
