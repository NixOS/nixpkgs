{ stdenv, fetchurl, guile }:

let
  name = "guile-lint-${version}";
  version = "14";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://download.tuxfamily.org/user42/${name}.tar.bz2";
    sha256 = "1gnhnmki05pkmzpbfc07vmb2iwza6vhy75y03bw2x2rk4fkggz2v";
  };

  buildInputs = [ guile ];

  unpackPhase = ''tar xjvf "$src" && sourceRoot="$PWD/${name}"'';

  prePatch = ''
    cat guile-lint.in |						\
    sed 's|^exec guile|exec $\{GUILE:-${guile}/bin/guile}|g' > ,,tmp &&	\
    mv ,,tmp guile-lint.in
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Checks syntax and semantics in a Guile program or module";
    homepage = "https://user42.tuxfamily.org/guile-lint/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.all;
  };
}
