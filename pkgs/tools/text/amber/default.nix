{ lib, stdenv, fetchFromGitHub, rustPlatform
, libiconv, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q0o2PQngbDLumck27V0bIiB35zesn55Y+MwK2GjNVWo=";
  };

  cargoHash = "sha256-nBSgP30Izskq9RbhVIyqWzZgG5ZWHVdiukldw+Q0rco=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
  };
}
