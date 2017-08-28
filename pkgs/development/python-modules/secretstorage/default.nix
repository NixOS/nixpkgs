{ stdenv, lib, pkgs, buildPythonPackage, dbus-python, python, cryptography }:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "2.3.1";
  name = "${pname}-${version}";

  src = pkgs.fetchFromGitHub {
    owner = "mitya57";
    repo = "secretstorage";
    rev = "2636a47b45aff51a21dfaf1cbd9f1f3c1347f7f4";
    sha256 = "1xs35ywqxxriwhm79kvivad0hszcm4ah29v34vbshlqvc66qr171";
  };

  postPatch = "patchShebangs .";
  propagatedBuildInputs = [ dbus-python cryptography ];
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mitya57/secretstorage";
    description = "Python bindings to FreeDesktop.org Secret Service API";
    license = lib.licenses.bsdOriginal;
    platforms = platforms.linux;
  };
}
