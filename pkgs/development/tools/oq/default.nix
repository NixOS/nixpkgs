{ lib
, fetchFromGitHub
, crystal
, jq
, libxml2
, makeWrapper
}:

crystal.buildCrystalPackage rec {
  pname = "oq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oLy8Ts+wnI0LxtAH6vVqhS7nqNkaLs0/vK9GxfG4vU8=";
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
