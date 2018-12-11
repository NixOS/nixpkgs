{ stdenv, nmap, jq, cifs-utils, sshfs, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name    = "rmount-${version}";
  version = "1.0.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner="Luis-Hebendanz";
    repo="rmount";
    sha256 = "1wjmfvbsq3126z51f2ivj85cjmkrzdm2acqsiyqs57qga2g6w5p9";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp ${src}/rmount.man $out/share/man/man1/rmount.1
    cp ${src}/rmount.bash $out/bin/rmount
    cp ${src}/config.json $out/share/config.json
    chmod +x $out/bin/rmount

    wrapProgram $out/bin/rmount --prefix PATH : ${stdenv.lib.makeBinPath [ nmap jq cifs-utils sshfs ]}
  '';

  meta = {
      homepage = "https://github.com/Luis-Hebendanz/rmount";
      description = "Remote mount utility which parses a json file";
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.luis ];
      platforms = stdenv.lib.platforms.linux;
    };
}
