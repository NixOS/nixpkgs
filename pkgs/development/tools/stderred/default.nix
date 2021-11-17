{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "stderred";
  version = "unstable-2021-04-28";

  src = fetchFromGitHub {
    owner = "sickill";
    repo = "stderred";
    rev = "b2238f7c72afb89ca9aaa2944d7f4db8141057ea";
    sha256 = "k/EA327AsRHgUYu7QqSF5yzOyO6h5XcE9Uv4l1VcIPI=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "stderr in red.";
    longDescription = ''
      stderred hooks on write() and a family of stream functions (fwrite, fprintf, error...) from libc in order to colorize all stderr output that goes to terminal thus making it distinguishable from stdout.
      Basically it wraps text that goes to file with descriptor "2" with proper ANSI escape codes making text red.
    '';
    homepage = "https://github.com/sickill/stderred";
    license = licenses.mit;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.unix;
  };
}
