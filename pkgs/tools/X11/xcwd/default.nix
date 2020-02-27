{ stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation {
  version = "2019-05-09";
  pname = "xcwd";

  src = fetchFromGitHub {
    owner   = "schischi";
    repo    = "xcwd";
    rev     = "99738e1176acf3f39c2e709236c3fd87b806f2ed";
    sha256  = "1wvhj5x8ysi1q73f9cw1f6znvp2zivd8pp6z1p3znw732h4zlv6v";
  };

  buildInputs = [ libX11 ];

  makeFlags = [ "prefix=$(out)" ];

  installPhase = ''
    install -D xcwd "$out/bin/xcwd"
  '';

  meta = with stdenv.lib; {
    description = ''
      A simple tool which print the current working directory of the currently focused window
    '';
    homepage = https://github.com/schischi/xcwd;
    maintainers = [ maintainers.grburst ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
