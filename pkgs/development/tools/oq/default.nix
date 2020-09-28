{ lib, fetchFromGitHub, crystal, jq, libxml2, makeWrapper, fetchpatch }:

crystal.buildCrystalPackage rec {
  pname = "oq";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zg4kxpfi3sap4cwp42zg46j5dv0nf926qdqm7k22ncm6jdrgpgw";
  };

  patches = [
    (fetchpatch {
        # remove once we have upgraded to oq 1.1.2+
        name = "yaml-test-leniency.patch";
        url = "https://github.com/Blacksmoke16/oq/commit/93ed2fe50c9ce3fd8d35427e007790ddaaafce60.patch";
        sha256 = "1iyz0c0w0ykz268bkrlqwvh1jnnrja0mqip6y89sbpa14lp0l37n";
    })
  ];

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
    platforms = platforms.unix;
  };
}
