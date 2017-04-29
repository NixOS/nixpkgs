{stdenv, fetchurl, guile}:

stdenv.mkDerivation rec {
  name = "guile-lint-14";
  src = fetchurl {
    url = "http://download.tuxfamily.org/user42/" + name + ".tar.bz2";
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

  meta = {
    description = "Guile-Lint checks syntax and semantics in a Guile program or module";
    homepage = http://user42.tuxfamily.org/guile-lint/index.html;
    license = "GPL";
    broken = true;
  };
}
