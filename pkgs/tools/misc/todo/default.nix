{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "todo";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "sioodmy";
    repo = "todo";
    rev = version;
    sha256 = "Z3kaCNZyknNHkZUsHARYh3iWWR+v//JhuYoMIrq54Wo=";
  };

  cargoSha256 = "82xB+9kiLBwCE6yC3tlmgzJJgA1cMDq6Mjc48GBZ9B8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
  preFixup = ''
    mv $out/bin/todo-bin $out/bin/todo
  '';
  meta = with lib; {
    description = "Simple todo cli program written in rust";
    homepage = "https://github.com/sioodmy/todo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sioodmy ];
    mainProgram = "todo";
  };
}
