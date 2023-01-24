{ lib, fetchFromGitHub }:
let
  version = "4.0.2";
in
fetchFromGitHub {
  name = "redhat-official-${version}";

  owner = "RedHatOfficial";
  repo = "RedHatFont";
  rev = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    for kind in mono proportional; do
      install -m444 -Dt $out/share/fonts/opentype fonts/$kind/static/otf/*.otf
      install -m444 -Dt $out/share/fonts/truetype fonts/$kind/static/ttf/*.ttf
    done
  '';

  sha256 = "sha256-904uQtbAdLx9MJudLk/vVk/+uK0nsPbWbAeXrWxTHm8=";

  meta = with lib; {
    homepage = "https://github.com/RedHatOfficial/RedHatFont";
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
