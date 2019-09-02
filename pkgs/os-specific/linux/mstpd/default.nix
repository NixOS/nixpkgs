{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mstpd";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "01majib6d1rixngf8c8vcrj1akf8nsqpxhdfdxxi2xwg23vx8f1a";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--prefix=$(out)"
    "--sysconfdir=$(out)/etc"
    "--sbindir=$(out)/sbin"
    "--libexecdir=$(out)/lib"
  ];

  meta = with stdenv.lib; {
    description = "Multiple Spanning Tree Protocol daemon";
    homepage = "https://github.com/mstpd/mstpd";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
