{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "tunnelto";
  version = "unstable-2022-09-25";

  src = fetchFromGitHub {
    owner = "agrinman";
    repo = pname;
    rev = "06428f13c638180dd349a4c42a17b569ab51a25f";
    sha256 = "sha256-84jGcR/E1QoqIlbGu67muYUtZU66ZJtj4tdZvmYbII4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QXkKqEEbNEDcypErDIFarJLuIoYWOZj/9jCbslxrOXs=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    description = "Expose your local web server to the internet with a public URL";
    homepage = "https://tunnelto.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
