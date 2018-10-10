{stdenv, fetchFromGitHub, autoreconfHook, cairo, libjpeg_turbo, libpng, libossp_uuid
,freerdp_legacy ,freerdp ,freerdpUnstable, pango, libssh2, libvncserver, libpulseaudio ,openssl, libvorbis, libwebp, pkgconfig, perl, libtelnet, inetutils,
makeWrapper}:

stdenv.mkDerivation rec {
  name = "guacamole-${version}";
  version = "0.9.14";

  src = fetchFromGitHub {
      owner = "apache";
      repo = "incubator-guacamole-server";
      rev = "7c191d7be0441a1cb64c90ab62d6535f3798eacb";
      sha256 = "105zrav6igvj0cvc8208bgp9jffc1w4mvmn3h7mkx6pgam50hnvs";
  };
  NIX_CFLAGS_COMPILE= [
    "-Wno-error=format-truncation"
    "-Wno-error=format-overflow"
  ];
  buildInputs = with stdenv; [ freerdp_legacy freerdp freerdpUnstable autoreconfHook pkgconfig cairo libpng libjpeg_turbo libossp_uuid pango libssh2 libvncserver libpulseaudio openssl libvorbis libwebp libtelnet perl makeWrapper];

  propogatedBuildInputs = with stdenv; [ freerdp_legacy freerdp autoreconfHook pkgconfig cairo libpng libjpeg_turbo libossp_uuid freerdp pango libssh2 libvncserver libpulseaudio openssl libvorbis libwebp inetutils];

  patchPhase = ''
    substituteInPlace ./src/protocols/rdp/keymaps/generate.pl --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace ./src/protocols/rdp/Makefile.am --replace "-Werror -Wall" "-Wall"
  '';
  postInstall = ''
    wrapProgram $out/sbin/guacd --prefix LD_LIBRARY_PATH ":" $out/lib
    '';

  meta = with stdenv.lib; {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.incubator.apache.org/";
    maintainers = [ stdenv.lib.maintainers.tomberek ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
