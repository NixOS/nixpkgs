{ lib, stdenv, fetchurl, makeWrapper, perl, perlPackages, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "findimagedupes";
  version = "2.19.1";

  # fetching this from GitHub does not contain the correct version number
  src = fetchurl {
    url = "http://www.jhnc.org/findimagedupes/findimagedupes-${version}.tar.gz";
    sha256 = "sha256-5NBPoXNZays5wzpQYar4uZZb0P/zB7fdecE+SjkJjcI=";
  };

  # Work around the "unpacker appears to have produced no directories"
  setSourceRoot = "sourceRoot=$(pwd)";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [ perl ] ++ (with perlPackages; [
    DBFile
    FileMimeInfo
    FileBaseDir
    #GraphicsMagick
    ImageMagick
    Inline
    InlineC
    ParseRecDescent
  ]);

  # use /tmp as a storage
  # replace GraphicsMagick with ImageMagick, because perl bindings are not yet available
  postPatch = ''
    substituteInPlace findimagedupes \
      --replace "DIRECTORY => '/usr/local/lib/findimagedupes';" "DIRECTORY => '/tmp';" \
      --replace "Graphics::Magick" "Image::Magick"
  '';

  buildPhase = "
    runHook preBuild
    ${perl}/bin/pod2man findimagedupes > findimagedupes.1
    runHook postBuild
  ";

  installPhase = ''
    runHook preInstall
    install -D -m 755 findimagedupes $out/bin/findimagedupes
    installManPage findimagedupes.1
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/findimagedupes" \
      --prefix PERL5LIB : "${with perlPackages; makePerlPath [
        DBFile
        FileMimeInfo
        FileBaseDir
        #GraphicsMagick
        ImageMagick
        Inline
        InlineC
        ParseRecDescent
      ]}"
  '';

  meta = with lib; {
    homepage = "http://www.jhnc.org/findimagedupes/";
    description = "Finds visually similar or duplicate images";
    license = licenses.gpl3;
    maintainers = with maintainers; [ stunkymonkey ];
  };
}
