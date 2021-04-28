{ lib
, fetchFromGitHub
, crystal
, jq
, libxml2
, makeWrapper
}:

crystal.buildCrystalPackage rec {
  pname = "oq";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vMW+N3N6H8S6dNm4eBJo2tSxSiouG92t4Nq3cYSWcw0=";
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
