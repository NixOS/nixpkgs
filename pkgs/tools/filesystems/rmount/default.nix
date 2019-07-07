{ stdenv, nmap, jq, cifs-utils, sshfs, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {

  pname   = "rmount";
  version = "1.0.1";

  src = fetchFromGitHub rec {
    rev = "v${version}";
    owner = "Luis-Hebendanz";
    repo = "rmount";
    sha256 = "1wjmfvbsq3126z51f2ivj85cjmkrzdm2acqsiyqs57qga2g6w5p9";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D ${src}/rmount.man  $out/share/man/man1/rmount.1
    install -D ${src}/rmount.bash $out/bin/rmount
    install -D ${src}/config.json $out/share/config.json

    wrapProgram $out/bin/rmount --prefix PATH : ${stdenv.lib.makeBinPath [ nmap jq cifs-utils sshfs ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Luis-Hebendanz/rmount;
    description = "Remote mount utility which parses a json file";
    license = licenses.mit;
    maintainers = [ maintainers.luis ];
    platforms = platforms.linux;
  };
}
