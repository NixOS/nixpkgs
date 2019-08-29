{ stdenv, autoreconfHook, fetchFromGitLab, libX11, xauth, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xtrace";
  version = "1.4.0";

  src = fetchFromGitLab rec {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = pname;
    rev = "xtrace-${version}";
    sha256 = "1yff6x847nksciail9jly41mv70sl8sadh0m5d847ypbjmxcwjpq";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper ];
  buildInputs = [ libX11 ];

  postInstall = ''
    wrapProgram "$out/bin/xtrace" \
        --prefix PATH ':' "${xauth}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = "https://salsa.debian.org/debian/xtrace";
    description = "Tool to trace X11 protocol connections";
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; linux;
  };
}
