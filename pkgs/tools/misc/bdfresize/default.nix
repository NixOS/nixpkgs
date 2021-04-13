{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "bdfresize";
  version = "1.5";

  src = fetchTarball {
    url = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/${pname}-${version}.tar.gz";
    sha256 = "1zccbv9nzs6344aq3kwlg91x1mxxnk5w0k9aa2amgggsi4j4p1hb";
  };

  patches = [ ./remove-malloc-declaration.patch ];

  meta = with lib; {
    description = "Tool to resize BDF fonts";
    homepage = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ malvo ];
  };
}
