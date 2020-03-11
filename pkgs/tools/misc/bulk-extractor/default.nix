{ stdenv, fetchFromGitHub, autoreconfHook, flex, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "bulk_extractor";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "simsong";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z4zb508gdsblv5jxcnpkwnhll3m6850rdy5v829c0marf9wyc5c";
    fetchSubmodules = true;
  };

  configureFlags = ["--disable-BEViewer"];

  enableParallelBuilding = true;
  nativeBuildInputs = [autoreconfHook];
  buildInputs = [flex openssl zlib];

  meta = with stdenv.lib; {
    description = "A program for scanning and extracting useful information";
    longDescription = ''
      bulk_extractor is a C++ program that scans a disk image, a file, or a directory of files and extracts useful information without
      parsing the file system or file system structures. The results are stored in feature files that can be easily inspected, parsed,
      or processed with automated tools.
    '';
    homepage = "https://github.com/simsong/bulk_extractor";
    downloadPage = "http://downloads.digitalcorpora.org/downloads/bulk_extractor/";
    changelog = "https://github.com/simsong/bulk_extractor/blob/v${version}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lightdiscord ];
    platforms = ["x86_64-linux"];
  };
}
