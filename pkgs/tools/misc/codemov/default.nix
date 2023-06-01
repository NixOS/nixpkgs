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
  version = "unstable-2023-05-28";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codemov";
    rev = "ab4b287c5cdb64f8a1f378c54070fde5a1f3be5b";
    hash = "sha256-miW/s3Ox2Z5qyFZqAp/FqHhc5jC6s+4DzxlHQhzCc2w=";
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
