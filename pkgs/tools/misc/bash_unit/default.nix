{ fetchFromGitHub
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bash_unit";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "pgrange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QWZnzliiqUfg6kXq1VGTNczupxNCgz1gFURrB/K2b4A=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bash_unit $out/bin/
  '';

  meta = with lib; {
    description = "Bash unit testing enterprise edition framework for professionals";
    maintainers = with maintainers; [ pamplemousse ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
  };
}
