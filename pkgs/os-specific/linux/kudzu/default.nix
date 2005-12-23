{stdenv, fetchurl, pciutils, python, popt, gettext}:

stdenv.mkDerivation {
  name = "kudzu-1.2.16";
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~armijn/.nix/kudzu-1.2.16.tar.gz;
    md5 = "5fc786dd558064fd9c9cb3e5be10e799";
  };
  buildInputs = [pciutils python popt gettext];
  patches = [./kudzu-python.patch];
}
