{ stdenv, fetchzip, fetchFromGitHub, ruby, dune_2, ocamlPackages
, ipaexfont, junicode, lmodern, lmmath
}:
let
  camlpdf = ocamlPackages.camlpdf.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "camlpdf";
      rev = "v2.3.1+satysfi";
      sha256 = "1s8wcqdkl1alvfcj67lhn3qdz8ikvd1v64f4q6bi4c0qj9lmp30k";
    };
  });
  otfm = ocamlPackages.otfm.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "otfm";
      rev = "v0.3.7+satysfi";
      sha256 = "0y8s0ij1vp1s4h5y1hn3ns76fzki2ba5ysqdib33akdav9krbj8p";
    };
  });
  yojson-with-position = ocamlPackages.buildDunePackage {
    pname = "yojson-with-position";
    version = "1.4.2";
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "yojson-with-position";
      rev = "v1.4.2+satysfi";
      sha256 = "17s5xrnpim54d1apy972b5l08bph4c0m5kzbndk600fl0vnlirnl";
    };
    useDune2 = true;
    nativeBuildInputs = [ ocamlPackages.cppo ];
    propagatedBuildInputs = [ ocamlPackages.biniou ];
    inherit (ocamlPackages.yojson) meta;
  };
in
  stdenv.mkDerivation rec {
    pname = "satysfi";
    version = "0.0.5";
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "SATySFi";
      rev = "v${version}";
      sha256 = "1y72by6d15bc6qb1lv1ch6cm1i74gyr0w127nnvs2s657snm0y1n";
      fetchSubmodules = true;
    };

    preConfigure = ''
      substituteInPlace src/frontend/main.ml --replace \
      '/usr/local/share/satysfi"; "/usr/share/satysfi' \
      $out/share/satysfi
    '';

    nativeBuildInputs = [ ruby dune_2 ];

    buildInputs = [ camlpdf otfm yojson-with-position ] ++ (with ocamlPackages; [
      ocaml findlib menhir
      batteries camlimages core_kernel ppx_deriving uutf omd cppo re
    ]);

    installPhase = ''
      cp -r ${ipaexfont}/share/fonts/opentype/* lib-satysfi/dist/fonts/
      cp -r ${junicode}/share/fonts/junicode-ttf/* lib-satysfi/dist/fonts/
      cp -r ${lmodern}/share/fonts/opentype/public/lm/* lib-satysfi/dist/fonts/
      cp -r ${lmmath}/share/fonts/opentype/latinmodern-math.otf lib-satysfi/dist/fonts/
      make install PREFIX=$out LIBDIR=$out/share/satysfi
      mkdir -p $out/share/satysfi/
      cp -r lib-satysfi/dist/ $out/share/satysfi/
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/gfngfn/SATySFi";
      description = "A statically-typed, functional typesetting system";
      license = licenses.lgpl3;
      maintainers = [ maintainers.mt-caret maintainers.marsam ];
      platforms = platforms.all;
    };
  }
