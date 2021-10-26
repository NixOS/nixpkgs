{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TUrCSpwbUP28COHAAFIdR5Kw18I35nBkiKU62IHCN4o=";
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
