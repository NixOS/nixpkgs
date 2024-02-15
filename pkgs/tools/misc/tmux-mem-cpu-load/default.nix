{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tmux-mem-cpu-load";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "thewtex";
    repo = "tmux-mem-cpu-load";
    rev = "v${version}";
    sha256 = "sha256-dRHV2XF3NFzd4HT9SbRnEn8U40QTnAUJDsM51NA9fEk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CPU, RAM, and load monitor for use with tmux";
    homepage = "https://github.com/thewtex/tmux-mem-cpu-load";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
    mainProgram = "tmux-mem-cpu-load";
  };
}
