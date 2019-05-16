{ stdenv, buildPythonApplication, buildPythonPackage, isPy3k, fetchurl, rpkg, offtrac, urlgrabber, pyopenssl, python_fedora }:

let
  fedora_cert = buildPythonPackage rec {
    name = "fedora-cert";
    version = "0.6.0.2";
    format = "other";

    src = fetchurl {
      url = "https://releases.pagure.org/fedora-packager/fedora-packager-${version}.tar.bz2";
      sha256 = "02f22072wx1zg3rhyfw6gbxryzcbh66s92nb98mb9kdhxixv6p0z";
    };
    propagatedBuildInputs = [ python_fedora pyopenssl ];
    doCheck = false;
  };
in buildPythonApplication rec {
  pname = "fedpkg";
  version = "1.29";

  disabled = isPy3k;

  src = fetchurl {
    url = "https://releases.pagure.org/fedpkg/${pname}-${version}.tar.bz2";
    sha256 = "1cpy5p1rp7w52ighz3ynvhyw04z86y8phq3n8563lj6ayr8pw631";
  };
  patches = [ ./fix-paths.patch ];
  propagatedBuildInputs = [ rpkg offtrac urlgrabber fedora_cert ];

  meta = with stdenv.lib; {
    description = "Subclass of the rpkg project for dealing with rpm packaging";
    homepage = https://pagure.io/fedpkg;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
