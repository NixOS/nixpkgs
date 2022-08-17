{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "remodel";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "remodel";
    rev = "v${version}";
    sha256 = "sha256-bUwTryGc4Y614nXKToPXp5KZqO12MmtdT3FUST4OvQY=";
  };

  cargoSha256 = "sha256-b9+eV2co4hcKLZxJRqDIX2U0O25Ba5UHQiNpfjE4fN4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Roblox file manipulation tool";
    longDescription = ''
      Remodel is a command line tool for manipulating Roblox files and the instances contained within them.
    '';
    homepage = "https://github.com/rojo-rbx/remodel";
    downloadPage = "https://github.com/rojo-rbx/remodel/releases/tag/v${version}";
    changelog = "https://github.com/rojo-rbx/remodel/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wackbyte ];
  };
}
