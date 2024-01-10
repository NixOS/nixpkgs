{ lib
, stdenv
, fetchFromGitHub
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "meson64-tools";
  version = "unstable-2023-07-25";

  src = fetchFromGitHub {
    owner = "angerman";
    repo = pname;
    rev = "b09cefd1e001dbba14036857bf6e167bf1833f26";
    hash = "sha256-/koIsslDNpaFHf1TV/0Xt0TiyhjL6tCz2oHQraYNhPA=";
  };

  nativeBuildInputs = with buildPackages; [ openssl bison flex bc python3 ];

  preBuild = ''
    patchShebangs --build .
    patchShebangs --build ./mbedtls/scripts/generate_psa_constants.py
    substituteInPlace mbedtls/programs/fuzz/Makefile --replace "python2" "python"
    substituteInPlace mbedtls/tests/Makefile --replace "python2" "python"
  '';

  # Also prefix tool names since some names are really generic (e.g. `pkg`).
  # Otherwise something could shadow those generic names in other builds.
  postInstall = ''
    (cd $out/bin
      for bin in *; do
        ln -s $bin meson64-g12-$bin
      done
    )
  '';

  makeFlags = [ "PREFIX=$(out)/bin" ];

  meta = with lib; {
    homepage = "https://github.com/angerman/meson64-tools";
    description = "Tools for Amlogic G12 platforms";
    license = licenses.mit;
    maintainers = with maintainers; [ oddlama ];
  };
}
