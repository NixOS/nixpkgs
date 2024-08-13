{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  perl,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cowsay";
  version = "3.8.1";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "cowsay-org";
    repo = "cowsay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4y+k1CzgTFq48g9gCzPTHdQFf3zgGTBm6tZTEXb7uTU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/cowsay \
      --suffix COWPATH : $out/share/cowsay/cows
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "cowsay --version";
    };
  };

  meta = with lib; {
    description = "Program which generates ASCII pictures of a cow with a message";
    homepage = "https://cowsay.diamonds";
    changelog = "https://github.com/cowsay-org/cowsay/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [
      rob
      anthonyroussel
    ];
    mainProgram = "cowsay";
  };
})
