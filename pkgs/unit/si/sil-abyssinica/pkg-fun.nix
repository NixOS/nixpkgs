{ fetchzip, lib }:

let
  version = "2.200";
in
fetchzip rec {
  name = "sil-abyssinica-${version}";
  url = "https://software.sil.org/downloads/r/abyssinica/AbyssinicaSIL-${version}.zip";
  sha256 = "sha256-Kvswqzw8remcu36QaVjeyk03cR4wW5BKQMDihiaxJoE=";

  postFetch = ''
    rm -rf $out/web
    mkdir -p $out/share/{fonts/truetype,doc/${name}}
    mv $out/*.ttf $out/share/fonts/truetype/
    mv $out/*.txt $out/documentation $out/share/doc/${name}/
  '';

  meta = with lib; {
    description = "Unicode font for Ethiopian and Erythrean scripts (Amharic et al.)";
    homepage = "https://software.sil.org/abyssinica/";
    license = licenses.ofl;
    maintainers = with maintainers; [ serge ];
    platforms = platforms.all;
  };
}
