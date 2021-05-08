{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-n89rfZwR8B6SKeLtzmbeHRyw2G9NIQ1BY6JvJuZmC/w=";
  };

  cargoSha256 = "sha256-RqtJLfBF9hfPh049uyc9K+uNBh+P3VMznuA2UtOwK3M=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  checkFlagsArray = [ "--skip=tests::cli" ];

  meta = with lib; {
    description = "Bundle any web page into a single HTML file";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
