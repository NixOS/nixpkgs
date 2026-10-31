{
  lib,
  stdenv,
  makeWrapper,
  curl,
  gmp,
  gnupg,
  libffi,
  libiconv,
  ncurses,
  zlib,
  openssl,
  stdenvNoCC,
  bash,
  coreutils,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ghcup";
  version = "0.1.50.1";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghcup/${finalAttrs.version}/x86_64-linux-ghcup-${finalAttrs.version}";
    hash = "sha256-s0hv7t5Xj+ywQnWkXYGHCIw/3Fltb0CqshTCFeq9siM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    curl
    gmp
    libffi
    ncurses
    zlib
    openssl
  ] ++ lib.optional stdenv.isDarwin libiconv;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/ghcup
    chmod +x $out/bin/ghcup

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    wrapProgram $out/bin/ghcup \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          gnupg
          bash
          coreutils
        ]
      }
    runHook postFixup
  '';

  meta = {
    description = "GHCup Haskell toolchain installer";
    longDescription = ''
      GHCup is an installer for the general purpose language Haskell.
      It can install the Glasgow Haskell Compiler (GHC), the Haskell build tool
      Cabal, the Haskell-centric IDE-compatible server HLS, and the
      Haskell-centric build tool Stack.
    '';
    homepage = "https://www.haskell.org/ghcup/";
    changelog = "https://github.com/haskell/ghcup-hs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.qxrein ];
    platforms = lib.platforms.unix;
    mainProgram = "ghcup";
  };
})
