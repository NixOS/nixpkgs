{ stdenv, fetchzip, fetchFromGitHub, ocamlPackages }:
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
in
  stdenv.mkDerivation rec {
    name = "satysfi-${version}";
    version = "2018-03-07";
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "SATySFi";
      rev = "a050ec0906d083682c630b0dea68887415b5f53d";
      sha256 = "12bhl7s2kc02amr8rm71pihj203f2j15y5j0kz3swgsw0gqh81gv";
      fetchSubmodules = true;
    };

    preConfigure = ''
      substituteInPlace src/frontend/main.ml --replace \
      '/usr/local/share/satysfi"; "/usr/share/satysfi' \
      $out/share/satysfi
    '';

    buildInputs = with ocamlPackages; [ ocaml ocamlbuild findlib menhir
      ppx_deriving uutf result core_kernel bitv batteries yojson camlimages ];
    installPhase = ''
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
