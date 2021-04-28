{ fetchFromGitHub
, bashInteractive
, jq
, makeWrapper
, p7zip
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "13n2y9gsgb8hnr64y083x9c90j3b4awcmdn81mqmwcydpby3q848";
  };

  buildInputs = [ bashInteractive ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/r2mod --prefix PATH : "${lib.makeBinPath [ jq p7zip ]}";
  '';

  meta = with lib; {
    description = "A Risk of Rain 2 Mod Manager in Bash";
    homepage = "https://github.com/foldex/r2mod_cli";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.reedrw ];
    platforms = platforms.unix;
  };
}
