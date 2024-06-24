{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "f2c";
  version = "20240312";

  src = fetchurl {
    url = "https://www.netlib.org/f2c/src.tgz";
    sha256 = "sha256-TTPve2fe31/Ad+xFAWy6NUIes2QyUi6NjFucN0pdb5k=";
  };

  makeFlags = [ "-f" "makefile.u" ];

  # Ensure xsum binary is built from scratch
  preBuild = "rm xsum";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/man/man1
    install -m755 f2c $out/bin
    install -m755 xsum $out/bin
    install f2c.1t $out/share/man/man1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Convert Fortran 77 source code to C";
    homepage = "https://www.netlib.org/f2c/";
    license = licenses.mit;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.unix;
  };
}
