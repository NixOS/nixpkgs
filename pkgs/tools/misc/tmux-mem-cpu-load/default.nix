{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tmux-mem-cpu-load";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "thewtex";
    repo = "tmux-mem-cpu-load";
    rev = "v${version}";
    sha256 = "1ybj513l4953jhayrzb47dlh4yv9bkvs0q1lfvky17v9fdkxgn2j";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CPU, RAM, and load monitor for use with tmux";
    homepage = https://github.com/thewtex/tmux-mem-cpu-load;
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
  };
}
