{lib, stdenv, fetchFromGitHub, perl}:

stdenv.mkDerivation rec {
  pname = "vmtouch";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "vmtouch";
    rev = "v${version}";
    sha256 = "08da6apzfkfjwasn4dxrlfxqfx7arl28apdzac5nvm0fhvws0dxk";
  };

  buildInputs = [perl];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Portable file system cache diagnostics and control";
    longDescription = "vmtouch is a tool for learning about and controlling the file system cache of unix and unix-like systems.";
    homepage = "https://hoytech.com/vmtouch/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.garrison ];
    platforms = lib.platforms.all;
    mainProgram = "vmtouch";
  };
}
