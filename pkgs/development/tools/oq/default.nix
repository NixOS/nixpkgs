{ lib, fetchFromGitHub, crystal, jq, libxml2, makeWrapper }:

crystal.buildCrystalPackage rec {
  pname = "oq";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zg4kxpfi3sap4cwp42zg46j5dv0nf926qdqm7k22ncm6jdrgpgw";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jq libxml2 ];

  format = "crystal";
  crystalBinaries.oq.src = "src/oq_cli.cr";

  preCheck = ''
    mkdir bin
    cp oq bin/oq
  '';

  postInstall = ''
    wrapProgram "$out/bin/oq" \
      --prefix PATH : "${lib.makeBinPath [ jq ]}"
  '';

  meta = with lib; {
    description = "A performant, and portable jq wrapper";
    homepage = "https://blacksmoke16.github.io/oq/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.linux;
  };
}
