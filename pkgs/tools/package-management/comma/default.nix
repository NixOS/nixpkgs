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
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    hash = "sha256-5M2VVrYH+IAa1P7Qz9gUPS3YNdqeVOoa1riV8eTtoYE=";
  };

  cargoHash = "sha256-kdhzoExiUAevid5NCCDTkK5CO+esa/SRGOcrITlr2fo=";

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
