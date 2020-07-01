{ stdenv, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname   = "smugpy";
  version = "20131218";

  src = fetchFromGitHub {
    owner  = "chrishoffman";
    repo   = pname;
    rev    = "f698d6749ce446e3d6c7d925b2cd1cd5b3d695ea";
    sha256 = "029x6hm1744iznv4sw8sfyl974wmx1sqnr1k5dvzzwpk3ja49a1y";
  };

  meta = with stdenv.lib; {
    description = "Python library for the SmugMug API";
    license = with licenses; [ mit ];
    homepage = "https://github.com/chrishoffman/smugpy";
  };

  doCheck = false; # Tries to login to Smugmug…
}
