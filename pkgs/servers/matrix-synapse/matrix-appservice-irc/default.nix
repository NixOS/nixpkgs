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
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-irc";
    rev = "refs/tags/${version}";
    hash = "sha256-d/CA27A0txnVnSCJeS/qeK90gOu1QjQaFBk+gblEdH8=";
  };

  npmDepsHash = "sha256-s/b/G49HlDbYsSmwRYrm4Bcv/81tHLC8Ac1IMEwGFW8=";

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
