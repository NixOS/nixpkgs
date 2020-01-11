{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "endlessh";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = pname;
    rev = version;
    sha256 = "186d7hf5p8yc46lmbrh0kxyfi1nrrx9n3w0jd9kh46vfwifjazra";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "SSH tarpit that slowly sends an endless banner";
    homepage = "https://github.com/skeeto/endlessh";
    license = licenses.unlicense;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}
