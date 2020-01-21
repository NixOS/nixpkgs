{ fetchFromGitHub
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bash_unit";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "pgrange";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jcjpcyf569b12vm4jrd53iqrrsjvr8sp9y29w2ls38fm8a16vr6";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bash_unit $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Bash unit testing enterprise edition framework for professionals";
    maintainers = with maintainers; [ pamplemousse ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
