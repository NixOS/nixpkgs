{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "isrcsubmit";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "JonnyJD";
    repo = "musicbrainz-isrcsubmit";
    rev = "v${version}";
    sha256 = "1lqs4jl2xv1zxmf0xsihk9rxzx2awq87g51vd7y3cq1vhj1icxqa";
  };

  propagatedBuildInputs = with python3Packages; [ musicbrainzngs discid ];

  meta = with lib; {
    # drutil is required on Darwin, which does not seem to be available in nixpkgs
    broken = true; # 2022-11-16
    description = "Script to submit ISRCs from disc to MusicBrainz";
    license = licenses.gpl3Plus;
    homepage = "http://jonnyjd.github.io/musicbrainz-isrcsubmit/";
    maintainers = with maintainers; [ ];
  };
}
