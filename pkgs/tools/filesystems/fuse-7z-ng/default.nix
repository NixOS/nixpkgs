{ lib
, stdenv
, fetchFromGitHub
, fuse
, p7zip
, cmake
, pkg-config
, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "fuse-7z-ng";
  version = "unstable-2018-07-20";

  src = fetchFromGitHub {
    owner = "kedazo";
    repo = pname;
    rev = "7b28cbdba1c2b51cbe3f4521336a1e833bf9cb97";
    sha256 = "sha256-oNljJTTZuO5XgbUwsiKlkoyf0S7AJglKU8fUBeUoyaQ=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper cmake ];

  buildInputs = [ fuse ];

  #preConfigure = "./autogen.sh";

  libs = lib.makeLibraryPath [ p7zip ]; # 'cause 7z.so is loaded manually

  postInstall = ''
    wrapProgram $out/bin/${pname} --suffix LD_LIBRARY_PATH : "${libs}/p7zip"

    mkdir -p $out/share/doc/${pname}
    cp TODO README NEWS COPYING ChangeLog AUTHORS $out/share/doc/${pname}/
  '';

  meta = with lib; {
    inherit (src.homepage);
    description = "A FUSE-based filesystem that uses the p7zip library";
    longDescription = ''
      fuse-7z-ng is a FUSE file system that uses the p7zip
      library to access all archive formats supported by 7-zip.

      This project is a fork of fuse-7z ( https://gitorious.org/fuse-7z/fuse-7z ).
    '';
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
