{ lib
, buildGoModule
, pkg-config
, libX11
, libXcursor
, libXrandr
, libXinerama
, libXi
, libXxf86vm
, libGL
, freetype
, fontconfig
, zlib
, harfbuzz
, openjpeg
, jbig2dec
, libjpeg_turbo
, gumbo
, mupdf
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "gcs";
  version = "5.16.0";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    rev = "v${version}";
    hash = "sha256-1xiAFA28VDCYyP/4lM3yuznbd+1HUPrinf7s/vBSrD8=";
  };
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi
    libXxf86vm
    libGL
    freetype
    fontconfig
    zlib
    harfbuzz
    openjpeg.dev
    jbig2dec
    libjpeg_turbo
    gumbo
    mupdf.dev
  ];

  vendorHash = "sha256-3CPYp4Dh+8s5vnMrCtL5w4lTs9maT7dns0HJqHtxm9o=";

  doCheck = false;

  # for some reason the preBuild runs both for the fetching derivation and the normal derivation
  preBuild = ''
    if [[ -e vendor/github.com/richardwilkes/pdf ]]; then
      substituteInPlace vendor/github.com/richardwilkes/pdf/pdf.go \
      --replace "linux LDFLAGS: -L\''${SRCDIR}/lib -lmupdf_linux_amd64 -lm" "pkg-config: mupdf zlib harfbuzz libopenjp2 jbig2dec gumbo"
    fi
  '';
  meta = with lib; {
    description = "A stand-alone, interactive, character sheet editor for the GURPS 4th Edition roleplaying game system";
    homepage = "https://gurpscharactersheet.com/";
    sourceProvenance = with sourceTypes; [
      fromSource
    ];
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [];
  };
}
