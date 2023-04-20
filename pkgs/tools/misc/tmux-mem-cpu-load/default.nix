{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tmux-mem-cpu-load";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "thewtex";
    repo = "tmux-mem-cpu-load";
    rev = "v${version}";
    sha256 = "sha256-4uSCYH31LO/69pxeur8byp9gYG6gaMYIiUxTmd7pag0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CPU, RAM, and load monitor for use with tmux";
    homepage = "https://github.com/thewtex/tmux-mem-cpu-load";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
  };
}
