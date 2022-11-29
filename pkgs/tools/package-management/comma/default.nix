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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    hash = "sha256-EPrXIDi0yO+AVriQgi3t91CLtmYtgmyEfWtFD+wH8As=";
  };

  cargoHash = "sha256-/1b3GF0flhvejZ3C/yOzRGl50sWR4IxprwRoMUYEvm8=";

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
