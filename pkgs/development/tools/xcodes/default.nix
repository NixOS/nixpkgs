{ lib
, stdenv
, fetchFromGitHub
, swift
, swiftpm
, swiftpm2nix
, makeWrapper
, CryptoKit
, LocalAuthentication
, libcompression
, aria2
}:
let
  generated = swiftpm2nix.helpers ./generated;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xcodes";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "XcodesOrg";
    repo = "xcodes";
    rev = finalAttrs.version;
    hash = "sha256-ARrSQ9ozM90Yg7y4WdU7jjNQ64sXHuhxZh/iNJcFfY0=";
  };

  nativeBuildInputs = [ swift swiftpm makeWrapper ];

  buildInputs = [
    CryptoKit
    LocalAuthentication
    libcompression
  ];

  configurePhase = generated.configure;

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    install -D $binPath/xcodes $out/bin/xcodes
    wrapProgram $out/bin/xcodes \
      --prefix PATH : ${lib.makeBinPath [ aria2 ]}

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/XcodesOrg/xcodes/releases/tag/${finalAttrs.version}";
    description = "Command-line tool to install and switch between multiple versions of Xcode";
    homepage = "https://github.com/XcodesOrg/xcodes";
    license = with licenses; [
      mit
      # unxip
      lgpl3Only
    ];
    maintainers = with maintainers; [ _0x120581f emilytrau ];
    platforms = platforms.darwin;
  };
})
