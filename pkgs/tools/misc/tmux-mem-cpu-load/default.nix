{ stdenv, fetchgit, cmake }:

stdenv.mkDerivation {
  pname = "tmux-mem-cpu-load";
  version = "v3.4.0";

  src = fetchgit {
    url = https://github.com/thewtex/tmux-mem-cpu-load.git;
    rev = "54fdf3c68c13f7a5fd1a1e998d801d0a24dd910a";
    sha256 = "1ybj513l4953jhayrzb47dlh4yv9bkvs0q1lfvky17v9fdkxgn2j";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [];

  meta = with stdenv.lib; {
    description = "CPU, RAM, and load monitor for use with tmux";
    homepage = https://github.com/thewtex/tmux-mem-cpu-load;
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = with platforms; linux ++ darwin ++ freebsd ++ openbsd ++ netbsd;
  };
}
