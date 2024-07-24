{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "simpleproxy";
  version = "3.5";
  rev = "v.${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "vzaliva";
    repo = "simpleproxy";
    sha256 = "1my9g4vp19dikx3fsbii4ichid1bs9b9in46bkg05gbljhj340f6";
  };

  meta = with lib; {
    homepage = "https://github.com/vzaliva/simpleproxy";
    description = "Simple TCP proxy";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.montag451 ];
    mainProgram = "simpleproxy";
  };
}
