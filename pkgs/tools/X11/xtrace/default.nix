{ stdenv, autoreconfHook, fetchgit, libX11, xauth, makeWrapper }:

let version = "1.3.1"; in
stdenv.mkDerivation {
  name = "xtrace-${version}";
  src = fetchgit {
    url = "git://git.debian.org/xtrace/xtrace.git";
    rev = "refs/tags/xtrace-1.3.1";
    sha256 = "1g26hr6rl7bbb9cwqk606nbbapslq3wnsy8j28azrgi8hgfqhjfi";
  };

  buildInputs = [ libX11 makeWrapper autoreconfHook ];

  preConfigure = ''
    ./autogen.sh
  '';

  postInstall =
    '' wrapProgram "$out/bin/xtrace" \
         --prefix PATH ':' "${xauth}/bin"
    '';

  meta = {
    homepage = http://xtrace.alioth.debian.org/;
    description = "Tool to trace X11 protocol connections";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
