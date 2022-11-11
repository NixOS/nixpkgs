{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "grace";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZNQORv17O8FuT33TM59IotiTG8thw3Gy9UyiC6mX5qI=";
  };

  vendorHash = "sha256-jFwf2npUfQae4naufIMymQa0izlKOTrXskkk+zLS5Lw=";

  meta = with lib; {
    homepage = "https://github.com/liamg/grace";
    description = "strace with colours";
    license = licenses.unlicense;
    maintainers = with maintainers; [ newam ];
    platforms = [ "x86_64-linux" ];
  };
}
