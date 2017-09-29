{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "simpleproxy-${version}";
  version = "3.5";
  rev = "v.${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "vzaliva";
    repo = "simpleproxy";
    sha256 = "1my9g4vp19dikx3fsbii4ichid1bs9b9in46bkg05gbljhj340f6";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/vzaliva/simpleproxy;
    description = "A simple TCP proxy";
    license = licenses.gpl2;
    maintainers = [ maintainers.montag451 ];
  };
}
