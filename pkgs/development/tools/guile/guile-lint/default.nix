{ stdenv, fetchurl, guile }:

let
  name = "guile-lint-${version}";
  version = "14";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://download.tuxfamily.org/user42/${name}.tar.bz2";
    sha256 = "5bfcf7a623338b2ef81ac097e3e136eaf32856dd0730b7eeaff3161067b5d0be";
  };

  buildInputs = [ guile ];

  unpackPhase = ''tar xjvf "$src" && sourceRoot="$PWD/${name}"'';

  patchPhase = ''
    cat guile-lint.in |						\
    sed 's|^exec guile|exec $\{GUILE:-${guile}/bin/guile}|g' > ,,tmp &&	\
    mv ,,tmp guile-lint.in
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Checks syntax and semantics in a Guile program or module";
    homepage = "https://user42.tuxfamily.org/guile-lint/index.html";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
