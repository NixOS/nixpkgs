{ stdenv
, fetchFromGitHub
, makeWrapper
, openssl
, which
, gnugrep
, gnused
, gawk
, mktemp
, coreutils
, findutils
}:

stdenv.mkDerivation rec {
  pname = "ssl-cert-check";
  version = "3.31";

  src = fetchFromGitHub {
    owner = "Matty9191";
    repo = pname;
    rev = "698c1996d05152cfaf2a1a3df4cc70482411fac8";
    sha256 = "0jvi9phs0ngfwrj9zixb03v9byavbwxx8xkp0h5m98qppn1kvl3n";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    openssl
    which
    gnugrep
    mktemp
    gawk
    gnused
    coreutils
    findutils
  ];

  prePatch = ''
    substituteInPlace $pname --replace PATH= NOT_PATH=
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $pname $out/bin/$pname
    wrapProgram $out/bin/$pname \
      --set PATH "${stdenv.lib.makeBinPath buildInputs}"
  '';

  meta = with stdenv.lib; {
    description = "a Bourne shell script that can be used to report on expiring SSL certificates";
    homepage = https://github.com/Matty9191/ssl-cert-check;
    license = licenses.gpl2;
    maintainers = [ maintainers.ryantm ];
    platforms = platforms.linux;
  };

}
