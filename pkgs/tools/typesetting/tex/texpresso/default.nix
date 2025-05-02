{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, writeScript
, mupdf
, SDL2
, re2c
, freetype
, jbig2dec
, harfbuzz
, openjpeg
, gumbo
, libjpeg
, texpresso-tectonic
}:

stdenv.mkDerivation rec {
  pname = "texpresso";
  version = "0-unstable-2024-04-18";

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
    rev = "62b2b5913420d92bb2863d9c92ac2072f7aaa5f9";
    hash = "sha256-kVGRuFVkJvQfl1bEjBU0pyx+SB+k5yI9C6XFiKZRpLQ=";
  };

  buildFlags = [ "texpresso" ];

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
    description = "Live rendering and error reporting for LaTeX.";
    maintainers = with lib.maintainers; [ nickhu ];
    license = lib.licenses.mit;
  };
}
