{ comma
, fetchFromGitHub
, fzy
, lib
, makeWrapper
, nix
, nix-index
, rustPlatform
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "comma";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    sha256 = "sha256-rXAX14yB8v9BOG4ZsdGEedpZAnNqhQ4DtjQwzFX/TLY=";
  };

  cargoSha256 = "sha256-9PVbiWmaTDx4iob5g9tXC+FV5Jmy6Id9tQxm05fJLkM=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/comma \
      --prefix PATH : ${lib.makeBinPath [ nix fzy nix-index ]}
    ln -s $out/bin/comma $out/bin/,
  '';

  passthru.tests = {
    version = testers.testVersion { package = comma; };
  };

  meta = with lib; {
    homepage = "https://github.com/nix-community/comma";
    description = "Runs programs without installing them";
    license = licenses.mit;
    maintainers = with maintainers; [ Enzime artturin ];
    platforms = platforms.all;
  };
}
