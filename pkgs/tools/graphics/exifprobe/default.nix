{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "exifprobe";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "hfiguiere";
    repo = "exifprobe";
    rev = "ce1ea2bc3dbbe8092b26f41cd89831cafe633d69";
    sha256 = "1c1fhc0v1m452lgnfcijnvrc0by06qfbhn3zkliqi60kv8l2isbp";
  };

  installFlags = [ "DESTDIR=$(out)" ];
  
  postInstall = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/share $out/share
    rm -r $out/usr
  '';

  meta = with stdenv.lib; {
    description =
      "Tool for reading EXIF data from image files produced by digital cameras";
    homepage = "https://github.com/hfiguiere/exifprobe";
    maintainers = with maintainers; [ btlvr ];
  };
}
