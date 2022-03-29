{ stdenvNoCC
, lib
, fetchFromGitHub
, ueberzug
, lf
, makeWrapper
, ffmpegthumbnailer
, imagemagick
, wkhtmltopdf
, epub-thumbnailer
, poppler_utils
, chafa
}:

stdenvNoCC.mkDerivation rec {
  pname = "lfimg";
  version = "87b1f6b";

  src = fetchFromGitHub {
    owner = "cirala";
    repo = pname;
    rev = version;
    sha256 = "0ykjhvl3yd8mwaf1vpz6wa0zph7ahn5pw88dk8vy62wm0d6aajgg";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 lfrun $out/bin/lfrun

    wrapProgram $out/bin/lfrun \
        --prefix PATH : ${lib.makeBinPath [
            ueberzug
            lf
            ffmpegthumbnailer
            imagemagick
            wkhtmltopdf
            epub-thumbnailer
            poppler_utils
            chafa
          ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/cirala/lfimg";
    description = "Image preview support for lf (list files) using Überzug";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ atila ];
    platforms = platforms.linux;
  };
}
