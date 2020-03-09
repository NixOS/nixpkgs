{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "endlessh";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = pname;
    rev = version;
    sha256 = "0ziwr8j1frsp3dajr8h5glkm1dn5cci404kazz5w1jfrp0736x68";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "SSH tarpit that slowly sends an endless banner";
    homepage = "https://github.com/skeeto/endlessh";
    changelog = "https://github.com/skeeto/endlessh/releases/tag/${version}";
    license = licenses.unlicense;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}
