{
  lib,
  fetchFromGitHub,
  rustPlatform,
  udev,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "g933-utils";
  version = "unstable-2021-11-19";

  src = fetchFromGitHub {
    owner = "ashkitten";
    repo = "g933-utils";
    rev = "1fc8cec375ed0d6f72191eadec788a49f51032d1";
    sha256 = "sha256-kGLMRqZHzRuXQNTjIuLz8JPC1c/ZK38msfkTIVnaomg=";
  };

  cargoSha256 = "sha256-FBX5hrS8tNWN83XX+x+s/mYyvO1h6V63bXCx7y0R8bY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "An application to configure Logitech wireless G933/G533 headsets";
    homepage = "https://github.com/ashkitten/g933-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
    platforms = platforms.linux;
    mainProgram = "g933-utils";
  };
}
