{ stdenv, fetchzip, fetchFromGitHub, ruby, dune, ocamlPackages
, ipaexfont, junicode
}:
let
  lm = fetchzip {
    url = "http://www.gust.org.pl/projects/e-foundry/latin-modern/download/lm2.004otf.zip";
    sha256 = "1mc88fbhfd2wki2vr700pgv96smya6d1z783xs3mfy138yb6ga2p";
    stripRoot = false;
  };
  lm-math = fetchzip {
    url = "http://www.gust.org.pl/projects/e-foundry/lm-math/download/latinmodern-math-1959.zip";
    sha256 = "15l3lxjciyjmbh0q6jjvzz16ibk4ij79in9fs47qhrfr2wrddpvs";
  };
  camlpdf = ocamlPackages.camlpdf.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "camlpdf";
      rev = "v2.2.1+satysfi";
      sha256 = "1s8v2i8nq52kz038bvc2n0spz68fpdq6kgxrabcs6zvml6n1frzy";
    };
  });
  otfm = ocamlPackages.otfm.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "otfm";
      rev = "v0.3.2+satysfi";
      sha256 = "1h795pdi5qi2nwymsfvb53x56h9pqi9iiqbzw10mi6fazgd2dzhd";
    };
  });
in
  stdenv.mkDerivation rec {
    name = "satysfi-${version}";
    version = "0.0.3";
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "SATySFi";
      rev = "v${version}";
      sha256 = "0qk284jhxnfb69s24j397a6155dhl4dcgamicin7sq04d0wj6c7f";
      fetchSubmodules = true;
    };

    preConfigure = ''
      substituteInPlace src/frontend/main.ml --replace \
      '/usr/local/share/satysfi"; "/usr/share/satysfi' \
      $out/share/satysfi
    '';

    nativeBuildInputs = [ ruby dune ];

    buildInputs = [ camlpdf otfm ] ++ (with ocamlPackages; [
      ocaml findlib menhir
      batteries camlimages core_kernel ppx_deriving uutf yojson
    ]);

    installPhase = ''
      cp -r ${ipaexfont}/share/fonts/opentype/* lib-satysfi/dist/fonts/
      cp -r ${junicode}/share/fonts/junicode-ttf/* lib-satysfi/dist/fonts/
      cp -r ${lm}/* lib-satysfi/dist/fonts/
      cp -r ${lm-math}/otf/latinmodern-math.otf lib-satysfi/dist/fonts/
      make install PREFIX=$out LIBDIR=$out/share/satysfi
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/gfngfn/SATySFi;
      description = "A statically-typed, functional typesetting system";
      license = licenses.lgpl3;
      maintainers = [ maintainers.mt-caret ];
      platforms = platforms.all;
    };
  }
