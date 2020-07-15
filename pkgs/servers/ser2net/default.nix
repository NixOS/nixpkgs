{ stdenv, lib, fetchFromGitHub, gensio, libyaml, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ser2net";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "154sc7aa74c2vwfwan41qwqxckp36lw9wf3qydamsyvd9ampjf5x";
  };

  buildInputs = [ pkgconfig autoreconfHook gensio libyaml ];

  meta = with lib; {
    description = "Serial to network connection server";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
