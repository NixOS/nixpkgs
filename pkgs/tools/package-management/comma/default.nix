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
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    hash = "sha256-x2HVm2vcEFHDrCQLIp5QzNsDARcbBfPdaIMLWVNfi4c=";
  };

  cargoHash = "sha256-N6Bc0+m0Qz1c/80oLvQTj8gvMusPXIriegNlRYWWStU=";

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
    mainProgram = "comma";
    maintainers = with maintainers; [ Enzime artturin marsam ];
  };
}
