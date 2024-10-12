{ stdenv, lib, runCommand, fetchFromGitHub, buildNpmPackage, python3, xcbuild, ffmpeg, nodePackages }:
let
  src = fetchFromGitHub {
    owner = "koush";
    repo = "scrypted";
    rev = "f359e7abcab5dc7d6824c2c5e9b05a762566131c";
    hash = "sha256-G3XUjpISypTUxtZce8sGBZ42qWemvgTOx7KVu+uGcwg=";
  };
in
buildNpmPackage {
  pname = "scrypted";
  version = "0.4.5.s6";

  src = "${src}/server";
  npmDepsHash = "sha256-PObEfY4G7m6Wnjs8al6NAl3GsHXo87x8SZxbwpCU59A=";

  patches = [ ./remove-bundled-ffmpeg.patch ];

  postPatch = ''
    substituteInPlace "src/plugin/media.ts" \
      --replace "import pathToFfmpeg from 'ffmpeg-static';" "const pathToFfmpeg = '$ffmpeg/bin/ffmpeg'";
  '';

  nativeBuildInputs = [
    python3
  ] ++ (lib.optional stdenv.isDarwin xcbuild);

  inherit ffmpeg;

  meta = with lib; {
    description = "A home video integration and automation platform";
    homepage = "https://www.scrypted.app/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ piperswe ];
  };
}
