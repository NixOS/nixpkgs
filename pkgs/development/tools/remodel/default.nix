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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "remodel";
    rev = "v${version}";
    sha256 = "sha256-tZ6ptGeNBULJaoFomMFN294wY8YUu1SrJh4UfOL/MnI=";
  };

  cargoHash = "sha256-YCYs+MMTxnJEKhzjddBp7lnSYPrpf3G+ktr1ez/ZKkg=";

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
    mainProgram = "remodel";
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
