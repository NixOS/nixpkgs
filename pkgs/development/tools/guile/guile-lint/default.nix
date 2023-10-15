{ lib
, stdenv
, fetchurl
, guile
}:

stdenv.mkDerivation rec {
  pname = "guile-lint";
  version = "14";

  src = fetchurl {
    url = "https://download.tuxfamily.org/user42/${pname}-${version}.tar.bz2";
    hash = "sha256-W/z3piMziy74GsCX4+E26vMoVt0HMLfur/MWEGe10L4=";
  };

  postPatch = ''
    substituteInPlace guile-lint.in --replace \
      "exec guile" "exec ${guile}/bin/guile"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    guile
  ];

  doCheck = true;

  meta = with lib; {
    description = "Checks syntax and semantics in a Guile program or module";
    homepage = "https://user42.tuxfamily.org/guile-lint/index.html";
    license = licenses.gpl3Plus;
    mainProgram = "guile-lint";
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.all;
  };
}
