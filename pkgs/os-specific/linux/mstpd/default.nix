{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mstpd";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1xkfydxljdnj49p5r3mirk4k146428b6imfc9bkfps9yjn64mkgb";
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
