{ stdenv, fetchgit, pkgconfig, autoreconfHook, fuse, p7zip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "fuse-7z-ng";

  src = fetchgit {
    url = "https://github.com/kedazo/fuse-7z-ng.git";
    rev = "eb5efb1f30";
    sha256 = "d4e017e4521f7ef98c7ebf6041c0db1092f68ab9ea70be475f1d3a44f28ffe6c";
  };

  buildInputs = [ autoreconfHook pkgconfig fuse makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fuse-7z-ng  \
      --prefix LD_LIBRARY_PATH : ${p7zip}/lib/p7zip
  '';

  meta = {
    description = "Mount archive formats using fuse and p7zip.";
    longDescription = ''
    fuse-7z-ng is a FUSE file system that uses the p7zip
    library to access all archive formats supported by 7-zip.

    This project is a fork of fuse-7z ( https://gitorious.org/fuse-7z/fuse-7z ).
    '';
    homepage = https://github.com/kedazo/fuse-7z-ng;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
