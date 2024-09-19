{ lib, stdenv, fetchFromGitHub, cmake, zlib, cups }:

stdenv.mkDerivation rec {
  pname = "brlaser";
  version = "6.2.6";

  src = fetchFromGitHub {
    owner = "Owl-Maintain";
    repo = "brlaser";
    rev = "0ee2128e220ab111c74205081e51020ad3d895e6";
    sha256 = "sha256-+W84s3Nulj0kz2h1WE7/QGysVylKkN/xNqcNvrQz6D8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib cups ];

  cmakeFlags = [ "-DCUPS_SERVER_BIN=lib/cups" "-DCUPS_DATA_DIR=share/cups" ];

  meta = with lib; {
    description = "CUPS driver for Brother laser printers";
    longDescription =
      ''
       Although most Brother printers support a standard printer language such as PCL or PostScript, not all do. If you have a monochrome Brother laser printer (or multi-function device) and the other open source drivers don't work, this one might help.

       This driver is known to work with many printers in the DCP, HL and MFC series, along with a few others.
       See the homepage for a full list.

      '';
    homepage = "https://github.com/Owl-Maintain/brlaser";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW ];
  };
}
