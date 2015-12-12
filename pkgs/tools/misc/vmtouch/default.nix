{stdenv, fetchFromGitHub, perl}:

stdenv.mkDerivation rec {
  pname = "vmtouch";
  version = "1.0.2";
  name = "${pname}-git-${version}";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "vmtouch";
    rev = "vmtouch-${version}";
    sha256 = "0m4s1am1r3qp8si3rnc8j2qc7sbf1k3gxvxr6fnpbf8fcfhh6cay";
  };

  buildInputs = [perl];

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Portable file system cache diagnostics and control";
    longDescription = "vmtouch is a tool for learning about and controlling the file system cache of unix and unix-like systems.";
    homepage = "http://hoytech.com/vmtouch/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.garrison ];
    platforms = stdenv.lib.platforms.all;
  };
}
