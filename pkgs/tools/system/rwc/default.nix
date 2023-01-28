{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "rwc";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-axHBkrbLEcYygCDofhqfIeZ5pv1sR34I5UgFUwVb2rI=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Report when files are changed";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ somasis ];
  };
}
