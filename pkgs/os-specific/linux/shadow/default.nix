{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "shadow-4.0.16";
   
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~armijn/.nix/shadow-4.0.16.tar.bz2;
    md5 = "1d91f7479143d1d705b94180c0d4874b";
  };
  configureFlags = "--with-selinux=no";
}
