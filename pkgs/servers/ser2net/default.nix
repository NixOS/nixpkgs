{ stdenv, lib, fetchFromGitHub, gensio, libyaml, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "ser2net";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1zl68mmd7pp10cjv1jk8rs2dlbwvzskyb58qvc7ph7vc6957lfhc";
  };

  buildInputs = [ autoreconfHook gensio libyaml ];

  meta = with lib; {
    description = "Serial to network connection server";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
