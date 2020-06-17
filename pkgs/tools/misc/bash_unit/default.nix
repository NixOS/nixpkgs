{ fetchFromGitHub
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bash_unit";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "pgrange";
    repo = pname;
    rev = "v${version}";
    sha256 = "02cam5gkhnlwhb9aqcqmkl8kskgikih0bmyx09ybi3gpaf4z82f7";
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
