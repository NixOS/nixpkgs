{ lib
, bat
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, gnumake
}:

rustPlatform.buildRustPackage rec {
  pname = "fzf-make";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Rpz10sHu/pzy/WX1yj0N78gVaw0fO8D92TSdtkmL/MU=";
  };

  cargoHash = "sha256-vy1LJciZMwMo0gxoEtfgESYnUPRhbpnyvciRZHk1Oao=";
  buildInputs = [ bat ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/fzf-make \
      --suffix PATH : ${lib.makeBinPath [ gnumake ]}
  '';

  meta = with lib; {
    description = "Fuzzy finder for Makefile";
    homepage = "https://github.com/kyu08/fzf-make";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ sigmanificient figsoda ];
    platforms = platforms.unix;
    mainProgram = pname;
  };
}
