{ lib, fetchFromGitHub, crystal, jq, libxml2, makeWrapper }:

crystal.buildCrystalPackage rec {
  pname = "oq";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sf6rb5b6g7gzyq11l5868p3a1s5z8432swlpv457bfbbnbg6j6q";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jq libxml2 ];

  crystalBinaries.oq.src = "src/oq_cli.cr";

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
