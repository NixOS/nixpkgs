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
<<<<<<< HEAD
  version = "1.7.1";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-x2HVm2vcEFHDrCQLIp5QzNsDARcbBfPdaIMLWVNfi4c=";
  };

  cargoHash = "sha256-N6Bc0+m0Qz1c/80oLvQTj8gvMusPXIriegNlRYWWStU=";
=======
    hash = "sha256-5HNH/Lqj8OU/piH3tvPRkINXHHkt6bRp0QYYR4xOybE=";
  };

  cargoHash = "sha256-4Epy5ZPyitRVTHEFVlRo66GvxJVBddlOII/7yqjuK9k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
