{ fetchFromGitHub
, jq
, makeWrapper
, p7zip
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "1g64f8ms7yz4rzm6xb93agc08kh9sbwkhvq35dpfhvi6v59j3n5m";
  };

  buildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/r2mod --prefix PATH : "${stdenv.lib.makeBinPath [ jq p7zip ]}";
  '';

  meta = with stdenv.lib; {
    description = "A Risk of Rain 2 Mod Manager in Bash";
    homepage = "https://github.com/foldex/r2mod_cli";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.reedrw ];
    platforms = platforms.linux;
  };
}
