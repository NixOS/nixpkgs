{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  gmp,
  gnupg,
  libffi,
  libiconv,
  ncurses,
  zlib,
  cabal-install,
  ghc,
  pkg-config,
  openssl,
  bash,
  coreutils,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "ghcup";
  version = "0.1.40.0";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghcup/${version}/x86_64-linux-ghcup-${version}";
    sha256 = "sha256-cMpStz7nlvXEO0JZ9/ztwqDWDYWmqe1AqC6oVT/KNKA=";
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
    changelog = "https://github.com/haskell/ghcup-hs/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.qxrein ];
    platforms = lib.platforms.unix;
    mainProgram = "ghcup";
  };
}
