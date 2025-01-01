{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  writeScript,
  mupdf,
  SDL2,
  re2c,
  freetype,
  jbig2dec,
  harfbuzz,
  openjpeg,
  gumbo,
  libjpeg,
  texpresso-tectonic,
}:

stdenv.mkDerivation rec {
  pname = "texpresso";
  version = "0-unstable-2024-07-02";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "CC=gcc" "CC=${stdenv.cc.targetPrefix}cc" \
      --replace-fail "LDCC=g++" "LDCC=${stdenv.cc.targetPrefix}c++"
  '';

  nativeBuildInputs = [
    makeWrapper
    mupdf
    SDL2
    re2c
    freetype
    jbig2dec
    harfbuzz
    openjpeg
    gumbo
    libjpeg
  ];

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "texpresso";
    rev = "0e14b1df6269b07c2c985f001e32b48673495a8b";
    hash = "sha256-av1yadR2giJUxFQuHSXFgTbCNsmccrzKOmLVnAGJt6c=";
  };

  buildFlags = [ "texpresso" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  installPhase = ''
    runHook preInstall
    install -Dm0755 -t "$out/bin/" "build/${pname}"
    runHook postInstall
  '';

  # needs to have texpresso-tonic on its path
  postInstall = ''
    wrapProgram $out/bin/texpresso \
      --prefix PATH : ${lib.makeBinPath [ texpresso-tectonic ]}
  '';

  passthru = {
    tectonic = texpresso-tectonic;
    updateScript = writeScript "update-texpresso" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq nix-update

      tectonic_version="$(curl -s "https://api.github.com/repos/let-def/texpresso/contents/tectonic" | jq -r '.sha')"
      nix-update --version=branch texpresso
      nix-update --version=branch=$tectonic_version texpresso.tectonic
    '';
  };

  meta = {
    inherit (src.meta) homepage;
    description = "Live rendering and error reporting for LaTeX";
    maintainers = with lib.maintainers; [ nickhu ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
