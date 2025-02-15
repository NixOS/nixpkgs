{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  Security,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-UFuWD3phcKuayQITd85Sou4ygDBMzjrR39vWrlseYJQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    Security
  ];

  meta = with lib; {
    description = "Code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
  };
}
