{ stdenv, fetchzip, fetchFromGitHub, ruby, dune, ocamlPackages
, ipaexfont, junicode, lmodern, lmmath
}:
let
  camlpdf = ocamlPackages.camlpdf.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "camlpdf";
      rev = "v2.2.2+satysfi";
      sha256 = "1dkyibjd8qb9fzljlzdsfdhb798vc9m8xqkd7295fm6bcfpr5r5k";
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
  yojson = ocamlPackages.yojson.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "yojson";
      rev = "v1.4.1+satysfi";
      sha256 = "06lajzycwmvc6s26cf40s9xn001cjxrpxijgfha3s4f4rpybb1mp";
    };
  });
in
  stdenv.mkDerivation rec {
    pname = "satysfi";
    version = "0.0.4";
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "SATySFi";
      rev = "v${version}";
      sha256 = "0ilvgixglklqwavf8p9mcbrjq6cjfm9pk4kqx163c0irh0lh0adv";
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
      batteries camlimages core_kernel ppx_deriving uutf yojson omd cppo re
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
      homepage = https://github.com/gfngfn/SATySFi;
      description = "A statically-typed, functional typesetting system";
      license = licenses.lgpl3;
      maintainers = [ maintainers.mt-caret maintainers.marsam ];
      platforms = platforms.all;
    };
  }
