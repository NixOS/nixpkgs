{ fetchFromGitHub
, jq
, makeWrapper
, p7zip
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "0as3nl9qiyf9daf2n78lyish319qclf2gbhr20mdd5wnqmxpk276";
  };

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
    platforms = platforms.linux;
  };
}
