<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, makeBinaryWrapper
, coreutils
, binutils-unwrapped
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectre-meltdown-checker";
  version = "0.46";
=======
{ lib, stdenv, fetchFromGitHub, makeWrapper, coreutils, binutils-unwrapped }:

stdenv.mkDerivation rec {
  pname = "spectre-meltdown-checker";
  version = "0.45";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-M4ngdtp2esZ+CSqZAiAeOnKtaK8Ra+TmQfMsr5q5gkg=";
=======
    rev = "v${version}";
    sha256 = "sha256-yGrsiPBux4YeiQ3BL2fnne5P55R/sQZ4FwzSkE6BqPc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  prePatch = ''
    substituteInPlace spectre-meltdown-checker.sh \
      --replace /bin/echo ${coreutils}/bin/echo
  '';

<<<<<<< HEAD
  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
=======
  nativeBuildInputs = [ makeWrapper ];

  installPhase = with lib; ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook preInstall

    install -Dm755 spectre-meltdown-checker.sh $out/bin/spectre-meltdown-checker
    wrapProgram $out/bin/spectre-meltdown-checker \
<<<<<<< HEAD
      --prefix PATH : ${lib.makeBinPath [ binutils-unwrapped ]}
=======
      --prefix PATH : ${makeBinPath [ binutils-unwrapped ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Spectre & Meltdown vulnerability/mitigation checker for Linux";
    homepage = "https://github.com/speed47/spectre-meltdown-checker";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.linux;
  };
})
=======
  meta = with lib; {
    description = "Spectre & Meltdown vulnerability/mitigation checker for Linux";
    homepage = "https://github.com/speed47/spectre-meltdown-checker";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
