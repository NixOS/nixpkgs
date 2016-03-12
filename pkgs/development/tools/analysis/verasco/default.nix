{ stdenv, fetchurl, coq, ocamlPackages
, tools ? stdenv.cc
}:

stdenv.mkDerivation rec {
  name = "verasco-1.3";
  src = fetchurl {
    url = "http://compcert.inria.fr/verasco/release/${name}.tgz";
    sha256 = "0zvljrpwnv443k939zlw1f7ijwx18nhnpr8jl3f01jc5v66hr2k8";
  };

  buildInputs = [ coq ] ++ (with ocamlPackages; [ ocaml findlib menhir zarith ]);

  preConfigure = ''
    substituteInPlace ./configure --replace '{toolprefix}gcc' '{toolprefix}cc'
  '';

  configureFlags = [
    "-toolprefix ${tools}/bin/"
    (if stdenv.isDarwin then "ia32-macosx" else "ia32-linux")
  ];

  prefixKey = "-prefix ";

  enableParallelBuilding = true;
  buildFlags = "proof extraction ccheck";

  installPhase = ''
    mkdir -p $out/bin
    cp ccheck $out/bin/
    ln -s $out/bin/ccheck $out/bin/verasco
    if [ -e verasco.ini ]
    then
      mkdir -p $out/share
      cp verasco.ini $out/share/
    fi
    mkdir -p $out/lib/compcert
    cp -riv runtime/include $out/lib/compcert
  '';

  meta = {
    homepage = http://compcert.inria.fr/verasco/;
    description = "A static analyzer for the CompCert subset of ISO C 1999";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    license = stdenv.lib.licenses.unfree;
    platforms = with stdenv.lib.platforms; darwin ++ linux;
  };
}
