{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "icingaweb2-theme-unicorn";
  version = "1.0.2";

  srcs = [
    (fetchFromGitHub {
      owner = "Mikesch-mp";
      repo = pname;
      rev = "v${version}";
      sha256 = "1qmcajdf0g70vp2avqa50lfrfigq22k91kggbgn5ablwyg9dki05";
    })
    (fetchurl {
      url = "http://i.imgur.com/SCfMd.png";
      sha256 = "1y6wqm1z6mn0a6jankd7pzqgi7zm5320kk6knvbv3qhzx2b74ypp";
    })
  ];

  unpackPhase = ''
    for src in $srcs; do
      case $src in
        *.png)
          cp $src unicorn.png
          ;;
        *)
          cp -r $src/* .
          ;;
      esac
    done
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
    chmod 755 $out/public/img
    cp unicorn.png "$out/public/img/unicorn.png"
  '';

  meta = with lib; {
    description = "Unicorn theme for IcingaWeb 2";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-unicorn";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
