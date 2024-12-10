{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  pname = "bbe";
  version = "0.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/bbe-/${version}/bbe-${version}.tar.gz";
    sha256 = "1nyxdqi4425sffjrylh7gl57lrssyk4018afb7mvrnd6fmbszbms";
  };

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [
    "out"
    "doc"
  ];

  meta = with lib; {
    description = "A sed-like editor for binary files";
    homepage = "https://bbe-.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.hhm ];
    mainProgram = "bbe";
  };
}
