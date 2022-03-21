{ lib
, fetchFromGitHub
, crystal
, jq
, libxml2
, makeWrapper
}:

crystal.buildCrystalPackage rec {
  pname = "oq";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iGKyP3NrAnR3ISOBq+YR/vwarlnIY4u4ZwdqSBnBC7U=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jq libxml2 ];

  format = "shards";

  postInstall = ''
    wrapProgram "$out/bin/oq" \
      --prefix PATH : "${lib.makeBinPath [ jq ]}"
  '';

  meta = with lib; {
    description = "A performant, and portable jq wrapper";
    homepage = "https://blacksmoke16.github.io/oq/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    platforms = platforms.unix;
  };
}
