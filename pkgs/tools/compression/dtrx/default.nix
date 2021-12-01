{ lib, fetchurl, python2Packages
, gnutar, unzip, lhasa, rpm, binutils, cpio, gzip, p7zip, cabextract, unrar, unshield
, bzip2, xz, lzip
# unzip is handled by p7zip
, unzipSupport ? false
, unrarSupport ? false }:

let
  archivers = lib.makeBinPath ([ gnutar lhasa rpm binutils cpio gzip p7zip cabextract unshield ]
  ++ lib.optional (unzipSupport) unzip
  ++ lib.optional (unrarSupport) unrar
  ++ [ bzip2 xz lzip ]);

in python2Packages.buildPythonApplication rec {
  pname = "dtrx";
  version = "7.1";

  src = fetchurl {
    url = "https://brettcsmith.org/2007/dtrx/dtrx-${version}.tar.gz";
    sha256 = "15yf4n27zbhvv0byfv3i89wl5zn6jc2wbc69lk5a3m6rx54gx6hw";
  };

  postInstall = ''
    wrapProgram "$out/bin/dtrx" --prefix PATH : "${archivers}"
  '';

  checkPhase = ''
    python2 tests/compare.py
  '';

  checkInputs = with python2Packages; [
    pyyaml
  ];

  # custom test suite fails
  doCheck = false;

  meta = with lib; {
    description = "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
    homepage = "https://brettcsmith.org/2007/dtrx/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}
