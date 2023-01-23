{ lib
, buildNpmPackage
, fetchFromGitHub
, python3
, matrix-sdk-crypto-nodejs
, nixosTests
, nix-update-script
}:

buildNpmPackage rec {
  pname = "matrix-appservice-irc";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-irc";
    rev = "refs/tags/${version}";
    hash = "sha256-8/jLONqf+0JRAK/SLj3qlG6Dm0VRl4h6YWeZnz4pVXc=";
  };

  npmDepsHash = "sha256-fGft7au5js9DRoXYccBPdJyaZ3zfsuCwUwWPOxwAodo=";

  nativeBuildInputs = [
    python3
  ];

  postInstall = ''
    rm -rv $out/lib/node_modules/matrix-appservice-irc/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -sv ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/lib/node_modules/matrix-appservice-irc/node_modules/@matrix-org/
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Node.js IRC bridge for Matrix";
    maintainers = with maintainers; [ rhysmdnz ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
