{ stdenv, fetchurl, libX11, xauth, makeWrapper }:

let version = "1.0.2"; in
stdenv.mkDerivation {
  name = "xtrace-${version}";
  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/3201/xtrace_${version}.orig.tar.gz";
    sha256 = "0czywk2iwj9vifml0qjlbz8n9jnqjsm4zz22haii82bf4l5w3y04";
  };

  buildInputs = [ libX11 makeWrapper ];

  postInstall =
    '' wrapProgram "$out/bin/xtrace" \
         --prefix PATH ':' "${xauth}/bin"
    '';

  meta = {
    homepage = http://xtrace.alioth.debian.org/;
    description = "xtrace, a tool to trace X11 protocol connections";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
