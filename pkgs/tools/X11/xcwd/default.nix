{ stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation {
  version = "2016-09-30";
  pname = "xcwd";

  src = fetchFromGitHub {
    owner   = "schischi";
    repo    = "xcwd";
    rev     = "3f0728b932904985b703b33bd5c936ea96cf15a0";
    sha256  = "0lwfz6qg7fkiq86skp51vpav33yik22ps4dvr48asv3570skhlf9";
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
