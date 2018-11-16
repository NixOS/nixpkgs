{stdenv, fetchFromGitHub, perl}:

stdenv.mkDerivation rec {
  pname = "vmtouch";
  version = "1.3.0";
  name = "${pname}-git-${version}";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "vmtouch";
    rev = "v${version}";
    sha256 = "0xpigfpwidk25k605y2m2g1952nzl5fgp0wn65hhn7hbra7srglf";
  };

  buildInputs = [perl];

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Portable file system cache diagnostics and control";
    longDescription = "vmtouch is a tool for learning about and controlling the file system cache of unix and unix-like systems.";
    homepage = https://hoytech.com/vmtouch/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.garrison ];
    platforms = stdenv.lib.platforms.all;
  };
}
