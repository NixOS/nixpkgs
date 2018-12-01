{ stdenv, buildPythonApplication, isPy3k, fetchurl, rpkg, offtrac, urlgrabber }:

buildPythonApplication rec {
  pname = "fedpkg";
  version = "1.29";

  disabled = isPy3k;

  src = fetchurl {
    url = "https://releases.pagure.org/fedpkg/${pname}-${version}.tar.bz2";
    sha256 = "1cpy5p1rp7w52ighz3ynvhyw04z86y8phq3n8563lj6ayr8pw631";
  };
  patches = [ ./fix-paths.patch ];
  propagatedBuildInputs = [ rpkg offtrac urlgrabber ];

  doCheck = false; # requires fedora_cert which isn't used anymore

  meta = with stdenv.lib; {
    description = "Subclass of the rpkg project for dealing with rpm packaging";
    homepage = https://pagure.io/fedpkg;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
