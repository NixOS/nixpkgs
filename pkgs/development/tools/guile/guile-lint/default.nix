{ stdenv, fetchurl, guile }:

stdenv.mkDerivation rec {
  name = "guile-lint-${version}";
  version = "14";

  src = fetchurl {
    url = "https://download.tuxfamily.org/user42/${name}.tar.bz2";
    sha256 = "1gnhnmki05pkmzpbfc07vmb2iwza6vhy75y03bw2x2rk4fkggz2v";
  };

  buildInputs = [ guile ];

  unpackPhase = ''tar xjvf "$src" && sourceRoot="$PWD/${name}"'';

  prePatch = ''
    substituteInPlace guile-lint.in --replace \
      "exec guile" "exec ${guile}/bin/guile"
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
