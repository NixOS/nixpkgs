{ lib, stdenv, python3, xmlto, docbook-xsl-nons, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "deheader";
  version = "1.8";
  outputs = [ "out" "man" ];

  src = fetchFromGitLab {
    owner = "esr";
    repo = "deheader";
    rev = "${version}";
    sha256 = "sha256-sjxgUtdsi/sfxOViDj7l8591TSYwtCzDQcHsk9ClXuM=";
  };

  buildInputs = [ python3 ];

  nativeBuildInputs = [ xmlto docbook-xsl-nons ];

  # With upstream Makefile, xmlto is called without "--skip-validation". It
  # makes it require a lot of dependencies, yet ultimately it fails
  # nevertheless in attempt to fetch something from SourceForge.
  buildPhase = ''
    runHook preBuild

    xmlto man --skip-validation deheader.xml
    patchShebangs ./deheader

    runHook postBuild
  '';

  # Normally "foundMakefile" variable is set by default buildPhase.
  foundMakefile = 1;
  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/man/man1}
    install -m 755 ./deheader $out/bin
    install -m 644 ./deheader.1 $out/share/man/man1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to find and optionally remove unneeded includes in C or C++ source files";
    longDescription = ''
      This tool takes a list of C or C++ sourcefiles and generates a report
      on which #includes can be omitted from them -- the test, for each foo.c
      or foo.cc or foo.cpp, is simply whether 'rm foo.o; make foo.o' returns a
      zero status. Optionally, with the -r option, the unneeded headers are removed.
      The tool also reports on headers required for strict portability.
    '';
    homepage = "http://catb.org/~esr/deheader";
    changelog = "https://gitlab.com/esr/deheader/-/blob/master/NEWS.adoc";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kaction ];

    # Single-file python3 script is probably unix-portable, but I am not
    # interested in dealing with anything but linux; feel free to add yourself
    # as another maintainer if you are. ~kaction, 2022-08-25
    platforms = platforms.linux;
  };
}
