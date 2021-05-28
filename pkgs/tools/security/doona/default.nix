{ fetchFromGitHub
, stdenv
, perl
}:

stdenv.mkDerivation rec {
  pname = "doona";
  version = "unstable-2019-03-08";

  src = fetchFromGitHub {
    owner = "wireghoul";
    repo = pname;
    rev = "master";
    sha256 = "0x9irwrw5x2ia6ch6gshadrlqrgdi1ivkadmr7j4m75k04a7nvz1";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r ${src}/bedmod $out/bin/bedmod
    cp ${src}/doona.pl $out/bin/doona
    chmod +x $out/bin/doona
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/wireghoul/doona";
    description = "A fork of the Bruteforce Exploit Detector Tool (BED)";
    longDescription = ''
      A fork of the Bruteforce Exploit Detector Tool (BED).
      BED is a program which is designed to check daemons for potential buffer overflows, format string bugs etc.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
