{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "hackertyper";
  version = "20190226";

  src = fetchFromGitHub {
    owner  = "Hurricane996";
    repo   = "Hackertyper";
    rev    = "dc017270777f12086271bb5a1162d0f3613903c4";
    sha256 = "0szkkkxspmfq1z2n4nldj2c9jn6jgiqik085rx1wkks0zgcdcgy1";
  };


  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ ncurses ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';



  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/hackertyper -v
  '';

  meta = with stdenv.lib; {
    description = "A C rewrite of hackertyper.net";
    homepage = "https://github.com/Hurricane996/Hackertyper";
    license = licenses.gpl3;
    maintainers = [ maintainers.marius851000 ];
  };
}
