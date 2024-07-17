{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "su-exec";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "ncopa";
    repo = "su-exec";
    rev = "v${version}";
    sha256 = "12vqlnpv48cjfh25sn98k1myc7h2wiv5qw2y2awgp6sipzv88abv";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -a su-exec $out/bin/su-exec
  '';

  meta = with lib; {
    description = "switch user and group id and exec";
    mainProgram = "su-exec";
    homepage = "https://github.com/ncopa/su-exec";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.linux;
  };
}
