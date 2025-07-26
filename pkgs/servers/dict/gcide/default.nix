{
  autoreconfHook,
  bison,
  dict,
  fetchurl,
  flex,
  lib,
  libmaa,
  stdenv,
  ...
}:

let
  sed-scripts = {
    check = ./sed-scripts/check.sed;
    fixes = ./sed-scripts/fixes.sed;
    post_webfilter = ./sed-scripts/post_webfilter.sed;
  };

  _major_debver = "0.48";
  _debver = "${_major_debver}.5+nmu4";
in
stdenv.mkDerivation rec {
  version = "0.53";

  pname = "dict-gcide";
  name = pname;
  dbName = pname;

  sourceRoot = "./${pname}";
  srcs = [
    (fetchurl {
      url = "https://deb.debian.org/debian/pool/main/d/${pname}/${pname}_${_debver}.tar.xz";
      hash = "sha256-45ITB4SnyRycjchdseFP5J+XhZfp6J2Dm5q+DJ/N4A4=";
    })
    (fetchurl {
      url = "https://ftp.gnu.org/gnu/gcide/gcide-${version}.tar.xz";
      hash = "sha256-06y9mE3hzgItXROZA4h7NiMuQ24w7KLLD7HAWN1/MZ8=";
    })
  ];

  buildInputs = [
    libmaa
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    dict
    flex
  ];

  prePatch = ''
    sed -Ei "/The Collaborative International Dictionary of English v.${_major_debver}/ {
      s/${_major_debver}/${version}/ ;
    }" scan.l;
  '';

  enableParallelBuilding = false;
  buildPhase = ''
    make -j1;

    ## Do the conversion explicitly, instead of `make db', to account for all
    ## the differences to the original build process.
    ## LANG=C is required so that the index file is properly sorted.
    sed -Ef "${sed-scripts.fixes}" ../gcide-${version}/CIDE.?  |
      sed -f debian/sedfile |
      ./webfilter |
      sed -Ef "${sed-scripts.post_webfilter}" |
      tee pre_webfmt.data |
      LANG=C ./webfmt -c;

    ## `dictzip -v' neglects to print a final newline.
    dictzip -v gcide.dict;
    printf '\n';
  '';

  doCheck = true;
  checkPhase = ''
    errors="$(sed -nEf "${sed-scripts.check}" < ./pre_webfmt.data)";

    if test -n "$errors"; then
      printf >&2 'Errors found:\n'
      printf >&2 '%s\n' "$errors"
      exit 1
    fi
  '';

  installPhase = ''
    install -Dm 0644 -t "$out/share/dictd/" ./gcide.{dict.dz,index};

    echo "en_US.UTF-8" > "$out/share/dictd/locale";

    install -Dm 0644 -t "$out/share/doc/dict-gcide/" ../gcide-${version}/{README,INFO,pronunc.txt};
  '';

  meta = {
    description = "GNU version of the Collaborative International Dictionary of English";
    homepage = "https://gcide.gnu.org.ua/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      S0AndS0
    ];
    platforms = lib.platforms.unix;
  };
}
