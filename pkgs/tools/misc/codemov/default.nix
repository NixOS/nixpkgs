{ lib
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, pkg-config
, oniguruma
, ffmpeg
, git
}:

rustPlatform.buildRustPackage {
  pname = "codemov";
  version = "unstable-2022-10-24";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codemov";
    rev = "d51e83246eafef32c3a3f54407fe49eb9801f5ea";
    hash = "sha256-4Z3XASFlALCnX1guDqhBfvGNZ0V1XSruJvvSm0xr/t4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    wrapProgram $out/bin/codemov \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg git ]}
  '';

  meta = with lib; {
    description = "Create a video of how a git repository's code changes over time";
    homepage = "https://github.com/sloganking/codemov";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
