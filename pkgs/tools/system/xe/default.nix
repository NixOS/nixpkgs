{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xe-${version}";
  version = "0.6.1";
  
  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "xe";
    rev = "v${version}";
    sha256 = "1dr3xlfq3zfdba1q96iags572lbk3z6s2179rs3pvsgkxn4m0qpf";
  };

  makeFlags = "PREFIX=$(out)";
  
  meta = with lib; {
    description = "Simple xargs and apply replacement";
    homepage = "https://github.com/chneukirchen/xe";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ndowens ];
  };
}
