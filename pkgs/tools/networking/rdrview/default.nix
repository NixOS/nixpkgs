{ stdenv, fetchFromGitHub, libxml2, curl, libseccomp }:

stdenv.mkDerivation {
  name = "rdrview";
  version = "unstable-2020-12-22";

  src = fetchFromGitHub {
    owner = "eafer";
    repo = "rdrview";
    rev = "7be01fb36a6ab3311a9ad1c8c2c75bf5c1345d93";
    sha256 = "00hnvrrrkyp5429rzcvabq2z00lp1l8wsqxw4h7qsdms707mjnxs";
  };

  buildInputs = [ libxml2 curl libseccomp ];

  installPhase = ''
    install -Dm755 rdrview -t $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Command line tool to extract main content from a webpage";
    homepage = "https://github.com/eafer/rdrview";
    license = licenses.asl20;
    maintainers = with maintainers; [ djanatyn ];
  };
}
