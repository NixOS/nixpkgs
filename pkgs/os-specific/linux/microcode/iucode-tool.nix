{ lib, stdenv, fetchFromGitLab, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "iucode-tool";
  version = "2.3.1";

  src = fetchFromGitLab {
    owner  = "iucode-tool";
    repo   = "iucode-tool";
    rev    = "v${version}";
    sha256 = "04dlisw87dd3q3hhmkqc5dd58cp22fzx3rzah7pvcyij135yjc3a";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel® 64 and IA-32 processor microcode tool";
    homepage = "https://gitlab.com/iucode-tool/iucode-tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
