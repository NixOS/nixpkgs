{ fetchFromGitHub
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bash_unit";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "pgrange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TtpVldIAqyv+apXmbI+1L0NgZxoKdc6Ffrl4WOqRI9c=";
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
