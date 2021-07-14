{ lib, buildGoModule, fetchFromGitHub, makeWrapper, stockfish }:

buildGoModule rec {
  pname = "uchess";
  version = "0.2.1";

  subPackages = [ "cmd/uchess" ];

  src = fetchFromGitHub {
    owner = "tmountain";
    repo = "uchess";
    rev = "v${version}";
    sha256 = "1njl3f41gshdpj431zkvpv2b7zmh4m2m5q6xsijb0c0058dk46mz";
  };

  vendorSha256 = "0dkq240ch1z3gihn8yc5d723nnvfxirk2nhw12r1c2hj1ga088g3";

  # package does not contain any tests as of v0.2.1
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uchess --suffix PATH : ${stockfish}/bin
  '';

  meta = with lib; {
    description = "Play chess against UCI engines in your terminal.";
    homepage = "https://tmountain.github.io/uchess/";
    maintainers = with maintainers; [ tmountain ];
    license = licenses.mit;
  };
}
