{ lib, stdenv, fetchgit, autoreconfHook, ffmpeg, flac, libvorbis, libogg, libid3tag, libexif, libjpeg, sqlite, gettext, nixosTests }:

let
  pname = "minidlna";
  version = "1.3.1";
in
stdenv.mkDerivation {
  inherit pname version;

  # tarball for 1.3.1 is missing
  src = fetchgit {
    url = "https://git.code.sf.net/p/${pname}/git";
    rev = "v${builtins.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-nbvz/QHSZBTZEqX/utOoOF5vorhrxGqIBA9qfpIZzyU=";
  };

  preConfigure = ''
    export makeFlags="INSTALLPREFIX=$out"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite gettext ];

  postInstall = ''
    mkdir -p $out/share/man/man{5,8}
    cp minidlna.conf.5 $out/share/man/man5
    cp minidlnad.8 $out/share/man/man8
  '';

  passthru.tests = { inherit (nixosTests) minidlna; };

  meta = with lib; {
    description = "Media server software";
    longDescription = ''
      MiniDLNA (aka ReadyDLNA) is server software with the aim of being fully
      compliant with DLNA/UPnP-AV clients.
    '';
    homepage = "https://sourceforge.net/projects/minidlna/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
