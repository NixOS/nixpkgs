{stdenv, fetchFromGitHub, perl}:

stdenv.mkDerivation rec {
  pname = "vmtouch";
  version = "git-20150310";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "vmtouch";
    rev = "4e1b106e59942678c1e6e490e2c7ca7df50eb7a3";
    sha256 = "1m37gvlypyfizd33mfyfha4hhwiyfzsj8gb2h5im6wzis4j15d0y";
  };

  buildInputs = [perl];

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Portable file system cache diagnostics and control";
    longDescription = "vmtouch is a tool for learning about and controlling the file system cache of unix and unix-like systems.";
    homepage = "http://hoytech.com/vmtouch/vmtouch.html";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.garrison ];
    platforms = stdenv.lib.platforms.all;
  };
}
