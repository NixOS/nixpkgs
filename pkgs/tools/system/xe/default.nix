{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xe-${version}";
  version = "0.5";
  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "xe";
    rev = "v${version}";
    sha256 = "0rv9npgjb695slql39asyp6znv9r3a6jbcsrsa1cmhk82iy4bljc";
  };
  makeFlags = "PREFIX=$(out)";
  meta = with lib; {
    description = "Simple xargs and apply replacement";
    homepage = "https://github.com/chneukirchen/xe";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
