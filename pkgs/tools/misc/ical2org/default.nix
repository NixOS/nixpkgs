{ stdenv, fetchFromGitHub, buildGoPackage}:

buildGoPackage rec {
  pname = "ical2org";
  version="1.1.5";

  goPackagePath = "github.com/rjhorniii/ical2org";

  src = fetchFromGitHub {
    owner = "rjhorniii";
    repo = "ical2org";
    rev = "v.${version}";
    sha256 = "0hdx2j2innjh0z4kxcfzwdl2d54nv0g9ai9fyacfiagjhnzgf7cm";
    fetchSubmodules = true;
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Convert an iCal file to org agenda format, optionally deduplicating entries.";
    homepage = https://github.com/rjhorniii/ical2org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ swflint ];
    platforms = platforms.unix;
  };
  
}
