{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.2.7b";
  pname = "discount";

  src = fetchFromGitHub {
    owner = "Orc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S6OVKYulhvEPRqNXBsvZ7m2W4cbdnrpZKPAo3SfD+9s=";
  };

  patches = [ ./fix-configure-path.patch ];
  configureScript = "./configure.sh";
  configureFlags = [
    "--shared"
    "--debian-glitch" # use deterministic mangling
    "--pkg-config"
    "--h1-title"
  ];

  enableParallelBuilding = true;
  installTargets = [ "install.everything" ];

  doCheck = true;

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libmarkdown.dylib $out/lib/libmarkdown.dylib
  '';

  meta = with lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = "http://www.pell.portland.or.us/~orc/Code/discount/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ shell ];
    mainProgram = "markdown";
    platforms = platforms.unix;
  };
}
