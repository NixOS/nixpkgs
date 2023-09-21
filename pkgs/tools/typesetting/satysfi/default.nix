{ lib, fetchFromGitHub, ocamlPackages
, ipaexfont, junicode, lmodern, lmmath
}:
let
  camlpdf = ocamlPackages.camlpdf.overrideAttrs {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "camlpdf";
      rev = "v2.3.1+satysfi";
      sha256 = "1s8wcqdkl1alvfcj67lhn3qdz8ikvd1v64f4q6bi4c0qj9lmp30k";
    };
  };
  otfm = ocamlPackages.otfm.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "otfm";
      rev = "v0.3.7+satysfi";
      sha256 = "0y8s0ij1vp1s4h5y1hn3ns76fzki2ba5ysqdib33akdav9krbj8p";
    };
    propagatedBuildInputs = o.propagatedBuildInputs ++ [ ocamlPackages.result ];
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
    duneVersion = "3";
    nativeBuildInputs = [ ocamlPackages.cppo ];
    propagatedBuildInputs = [ ocamlPackages.biniou ];
    inherit (ocamlPackages.yojson) meta;
  };
in
  ocamlPackages.buildDunePackage rec {
    pname = "satysfi";
    version = "0.0.8";
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "SATySFi";
      rev = "v${version}";
      sha256 = "sha256-cVGe1N3qMlEGAE/jPUji/X3zlijadayka1OL6iFioY4=";
      fetchSubmodules = true;
    };

    preConfigure = ''
      substituteInPlace src/frontend/main.ml --replace \
      '/usr/local/share/satysfi"; "/usr/share/satysfi' \
      $out/share/satysfi
    '';

    duneVersion = "3";

    nativeBuildInputs = with ocamlPackages; [ menhir cppo ];

    buildInputs = [ camlpdf otfm yojson-with-position ] ++ (with ocamlPackages; [
      menhirLib
      batteries camlimages core_kernel ppx_deriving uutf omd re
    ]);

    postInstall = ''
      mkdir -p $out/share/satysfi/dist/fonts
      cp -r lib-satysfi/dist/ $out/share/satysfi/
      cp -r \
        ${ipaexfont}/share/fonts/opentype/* \
        ${junicode}/share/fonts/junicode-ttf/* \
        ${lmodern}/share/fonts/opentype/public/lm/* \
        ${lmmath}/share/fonts/opentype/latinmodern-math.otf \
        $out/share/satysfi/dist/fonts
    '';

    meta = with lib; {
      homepage = "https://github.com/gfngfn/SATySFi";
      description = "A statically-typed, functional typesetting system";
      changelog = "https://github.com/gfngfn/SATySFi/blob/v${version}/CHANGELOG.md";
      license = licenses.lgpl3Only;
      maintainers = [ maintainers.mt-caret maintainers.marsam ];
      platforms = platforms.all;
    };
  }
