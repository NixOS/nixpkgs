{stdenv, fetchFromGitHub, perl}:

stdenv.mkDerivation rec {
  pname = "vmtouch";
  version = "1.1.0";
  name = "${pname}-git-${version}";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "vmtouch";
    rev = "v${version}";
    sha256 = "1cr8bw3favdvc3kc05n1r7f5fibqqv54bn3z2jwj70br8s5g0qx0";
  };

  buildInputs = [perl];

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Portable file system cache diagnostics and control";
    longDescription = "vmtouch is a tool for learning about and controlling the file system cache of unix and unix-like systems.";
    homepage = http://hoytech.com/vmtouch/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.garrison ];
    platforms = stdenv.lib.platforms.all;
  };
}
