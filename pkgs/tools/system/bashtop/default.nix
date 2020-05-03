{ stdenv
, fetchFromGitHub
, bash_5
, curl
, lm_sensors
, procps
, sysstat
}:

stdenv.mkDerivation rec {
  pname = "bashtop";
  version = "0.8.23";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y6yxm2vmbz0373cfdl6mjh8vhs0r0wcng82n304klx90qxg3ljp";
  };

  buildInputs = [ bash_5 curl lm_sensors procps sysstat ];

  dontBuild = true;
  installPhase = ''
    install -Dm755 ${pname} $out/bin/${pname}
  '';

  meta = with stdenv.lib; {
    description = "Linux resource monitor";
    homepage = "https://github.com/aristocratos/bashtop";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.linux;
  };
}
