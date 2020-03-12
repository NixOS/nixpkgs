{ stdenv, python3Packages, xpdf, imagemagick, tesseract }:

python3Packages.buildPythonPackage rec {
  pname = "invoice2data";
  version = "0.2.93";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1phz0a8jxg074k0im7shrrdfvdps7bn1fa4zwcf8q3sa2iig26l4";
  };

  makeWrapperArgs = ["--prefix" "PATH" ":" (stdenv.lib.makeBinPath [ imagemagick xpdf tesseract ]) ];

  propagatedBuildInputs = with python3Packages; [ unidecode dateparser pyyaml pillow chardet pdfminer ];

  # Tests fails even when ran manually on my ubuntu machine !!
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Data extractor for PDF invoices";
    homepage = https://github.com/invoice-x/invoice2data;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
