{ lib, stdenv, fetchFromGitHub, pkg-config, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  pname = "pngquant";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "pngquant";
    rev = version;
    sha256 = "sha256-D2KNn6AJ4eIHeb/2Oo1Wf0djMCXTtVGrua0D6z7+9V4=";
    fetchSubmodules = true;
  };

  preConfigure = "patchShebangs .";

  configureFlags = lib.optionals (!stdenv.hostPlatform.isx86) [ "--disable-sse" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpng zlib lcms2 ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://pngquant.org/";
    description = "A tool to convert 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    changelog = "https://github.com/kornelski/pngquant/raw/${version}/CHANGELOG";
    platforms = platforms.unix;
    license = with licenses; [ gpl3Plus hpnd bsd2 ];
    mainProgram = "pngquant";
    maintainers = [ maintainers.srapenne ];
  };
}
