{ xorg, lib, stdenv, libev, fetchFromGitHub, pkg-config }:

stdenv.mkDerivation rec {
  pname = "xmousepasteblock";
  version = "1.3";
  src = fetchFromGitHub {
    owner = "milaq";
    repo = "XMousePasteBlock";
    hash = "sha256-0rpAbYUU0SoeQaVNStmIEuYyiWbRAdTN7Mvm0ySDnhU=";
    rev = version;
  };
  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];
  buildInputs = with xorg; [ libX11 libXext libXi libev ];
  nativeBuildInputs = [ pkg-config ];
  meta = with lib; {
    description = "Middle mouse button primary X selection/clipboard paste disabler";
    homepage = "https://github.com/milaq/XMousePasteBlock";
    license = lib.licenses.gpl2;
    maintainers = [ maintainers.petercommand ];
  };
}
