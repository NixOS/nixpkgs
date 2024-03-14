{ stdenv
, fetchzip
, suffix
, revision
}:
stdenv.mkDerivation {
  name = "ffmpeg";
  src = fetchzip {
    url = "https://playwright.azureedge.net/builds/ffmpeg/${revision}/ffmpeg-${suffix}.zip";
    hash = "sha256-47/7qePyA1OFW4WJAZaKdoa3aJSrLJi9zVsCPYjrCEw=";
    stripRoot = false;
  };
  buildPhase = ''
    cp -R . $out
  '';
}
