{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.0.24";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vl62v92TmXNR6x7LDmNpiOlOgNNm0WuZva1SCKqqvbQ=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
