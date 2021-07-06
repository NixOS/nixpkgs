{ lib
, fetchFromGitHub
, python3
, installShellFiles
, bash
, pandoc
}:

# FIXME: how to "recommend" apksigner like the Debian package?

python3.pkgs.buildPythonApplication rec {
  pname = "apksigcopier";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "apksigcopier";
    rev = "v${version}";
    sha256 = "1la1ml91jvqc1zakbqfpayjbs67pi3i18bsgz3mf11rxgphd3fpk";
  };

  nativeBuildInputs = [ installShellFiles pandoc ];
  propagatedBuildInputs = with python3.pkgs; [ click ];
  checkInputs = with python3.pkgs; [ flake8 mypy pylint ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /bin/bash ${bash}/bin/bash \
      --replace 'apksigcopier --version' '${python3.interpreter} apksigcopier --version'
  '';

  postBuild = ''
    make ${pname}.1
  '';

  checkPhase = ''
    make test
  '';

  postInstall = ''
    installManPage ${pname}.1
  '';

  meta = with lib; {
    description = "Copy/extract/patch apk signatures & compare apks";
    longDescription = ''
      apksigcopier is a tool for copying APK signatures from a signed APK
      to an unsigned one (in order to verify reproducible builds).  It can
      also be used to compare two APKs with different signatures.  Its
      command-line tool offers four operations:

      * copy signatures directly from a signed to an unsigned APK
      * extract signatures from a signed APK to a directory
      * patch previously extracted signatures onto an unsigned APK
      * compare two APKs with different signatures (requires apksigner)
    '';
    homepage = "https://github.com/obfusk/apksigcopier";
    license = with licenses; [ gpl3Plus ];
    maintainers = [ maintainers.obfusk ];
  };
}
