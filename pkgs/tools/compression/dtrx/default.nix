{ lib
, fetchFromGitHub
, python3Packages
, gnutar
, unzip
, lhasa
, rpm
, binutils
, cpio
, gzip
, p7zip
, cabextract
, unrar
, unshield
, bzip2
, xz
, lzip
, unzipSupport ? false
, unrarSupport ? false
}:

python3Packages.buildPythonApplication rec {
  pname = "dtrx";
  version = "8.5.1";

  src = fetchFromGitHub {
    owner = "dtrx-py";
    repo = "dtrx";
    rev = "refs/tags/${version}";
    sha256 = "sha256-KOHafmvl17IABlcBuE7isHVCIYRbA68Dna6rgiiWlkQ=";
  };

  postInstall =
    let
      archivers = lib.makeBinPath (
        [ gnutar lhasa rpm binutils cpio gzip p7zip cabextract unshield bzip2 xz lzip ]
        ++ lib.optional (unzipSupport) unzip
        ++ lib.optional (unrarSupport) unrar
      );
    in ''
      wrapProgram "$out/bin/dtrx" --prefix PATH : "${archivers}"
    '';

  nativeBuildInputs = [ python3Packages.invoke ];

  meta = with lib; {
    description = "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
    homepage = "https://github.com/dtrx-py/dtrx";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.spwhitt ];
  };
}
