{ cmake, fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "stderred";
  version = "unstable-2021-05-15";

  src = fetchFromGitHub {
    owner = "sickill";
    repo = "stderred";
    rev = "b2238f7c72afb89ca9aaa2944d7f4db8141057ea";
    sha256 = "1wi0biargy2byl27grd1xv4cwb77hnj45fwba7h13cf0dvgh1wck";
  };

  nativeBuildInputs = [
    cmake
  ];

  sourceRoot = "${src.name}/src";

  meta = with lib; {
    description = "stderr in red";
    longDescription = '' stderred hooks on write() and a family of stream
      functions (fwrite, fprintf, error...) from libc in order to colorize
      all stderr output that goes to terminal thus making it distinguishable
      from stdout. Basically it wraps text that goes to file with descriptor
      "2" with proper ANSI escape codes making text red.
      It's implemented as a shared library and doesn't require recompilation
      of existing binaries thanks to preload/insert feature of dynamic
      linkers.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.scoder12 ];
    platforms = platforms.unix;
  };
}
