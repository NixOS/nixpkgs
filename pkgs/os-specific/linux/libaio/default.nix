{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "libaio-0.3.109";

  src = fetchgit {
    url = https://git.fedorahosted.org/git/libaio.git;
    rev = "refs/tags/${name}";
    sha256 = "1wbziq0hqvnbckpxrz1cgr8dlw3mifs4xpy3qhnagbrrsmrq2rhi";
  };

  makeFlags = "prefix=$(out)";

  meta = {
    description = "Library for asynchronous I/O in Linux";
    homepage = http://lse.sourceforge.net/io/aio.html;
    platforms = stdenv.lib.platforms.linux;
  };
}
