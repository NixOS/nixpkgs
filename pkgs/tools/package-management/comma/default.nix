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
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    sha256 = "sha256-emhvBaicLAnu/Kn4oxHngGa5BSxOEwbkhTLO5XvauMw=";
  };

  cargoSha256 = "sha256-mQxNo4VjW2Q0MYfU+RCb4Ayl9ClpxrSV8X4EKZ7PewA=";

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
