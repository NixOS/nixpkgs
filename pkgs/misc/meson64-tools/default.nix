{ lib, stdenv, fetchFromGitHub, buildPackages }:

stdenv.mkDerivation rec {
  pname = "meson64-tools";
  version = "unstable-2020-08-03";

  src = fetchFromGitHub {
    owner = "angerman";
    repo = pname;
    rev = "a2d57d11fd8b4242b903c10dca9d25f7f99d8ff0";
    sha256 = "1487cr7sv34yry8f0chaj6s2g3736dzq0aqw239ahdy30yg7hb2v";
  };

  buildInputs = with buildPackages; [ openssl bison yacc flex bc python3 ];

  preBuild = ''
    patchShebangs .
    substituteInPlace mbedtls/programs/fuzz/Makefile --replace "python2" "python"
    substituteInPlace mbedtls/tests/Makefile --replace "python2" "python"
  '';

  # Also prefix tool names since some names are really generic (e.g. `pkg`).
  # Otherwise something could shadow those generic names in other builds.
  postInstall = ''
    (cd $out/bin
      for bin in *; do
        ln -s $bin meson64-$bin
      done
    )
  '';

  makeFlags = [ "PREFIX=$(out)/bin" ];

  meta = with lib; {
    homepage = "https://github.com/angerman/meson64-tools";
    description = "Tools for Amlogic Meson ARM64 platforms";
    license = licenses.unfree; # https://github.com/angerman/meson64-tools/issues/2
    maintainers = with maintainers; [ aarapov ];
  };
}
