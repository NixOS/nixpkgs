{ comma
, fetchFromGitHub
, fzy
, lib
, makeBinaryWrapper
, nix-index-unwrapped
, rustPlatform
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "comma";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    hash = "sha256-5HNH/Lqj8OU/piH3tvPRkINXHHkt6bRp0QYYR4xOybE=";
  };

  cargoHash = "sha256-4Epy5ZPyitRVTHEFVlRo66GvxJVBddlOII/7yqjuK9k=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/comma \
      --prefix PATH : ${lib.makeBinPath [ fzy nix-index-unwrapped ]}
    ln -s $out/bin/comma $out/bin/,
  '';

  passthru.tests = {
    version = testers.testVersion { package = comma; };
  };

  meta = with lib; {
    homepage = "https://github.com/nix-community/comma";
    description = "Runs programs without installing them";
    license = licenses.mit;
    maintainers = with maintainers; [ Enzime artturin marsam ];
  };
}
