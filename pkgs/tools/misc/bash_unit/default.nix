{ fetchFromGitHub
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bash_unit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "pgrange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ekkyyp280YRXMuNXbiV78Hrfd/zk2nESE1bRCpUP1eE=";
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
