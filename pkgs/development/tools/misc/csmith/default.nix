{
  lib,
  stdenv,
  fetchurl,
  m4,
  makeWrapper,
  libbsd,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "csmith";
  version = "2.3.0";

  src = fetchurl {
    url = "https://embed.cs.utah.edu/csmith/${pname}-${version}.tar.gz";
    sha256 = "1mb5zgixsyf86slggs756k8a5ddmj980md3ic9sa1y75xl5cqizj";
  };

  nativeBuildInputs = [
    m4
    makeWrapper
  ];
  buildInputs =
    [ libbsd ]
    ++ (with perlPackages; [
      perl
      SysCPU
    ]);

  CXXFLAGS = "-std=c++98";

  postInstall = ''
    substituteInPlace $out/bin/compiler_test.pl \
      --replace '$CSMITH_HOME/runtime' $out/include/${pname}-${version} \
      --replace ' ''${CSMITH_HOME}/runtime' " $out/include/${pname}-${version}" \
      --replace '$CSMITH_HOME/src/csmith' $out/bin/csmith

    substituteInPlace $out/bin/launchn.pl \
      --replace '../compiler_test.pl' $out/bin/compiler_test.pl \
      --replace '../$CONFIG_FILE' '$CONFIG_FILE'

    wrapProgram $out/bin/launchn.pl \
      --prefix PERL5LIB : "$PERL5LIB"

    mkdir -p $out/share/csmith
    mv $out/bin/compiler_test.in $out/share/csmith/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A random generator of C programs";
    homepage = "https://embed.cs.utah.edu/csmith";
    # Officially, the license is this: https://github.com/csmith-project/csmith/blob/master/COPYING
    license = licenses.bsd2;
    longDescription = ''
      Csmith is a tool that can generate random C programs that statically and
      dynamically conform to the C99 standard. It is useful for stress-testing
      compilers, static analyzers, and other tools that process C code.
      Csmith has found bugs in every tool that it has tested, and has been used
      to find and report more than 400 previously unknown compiler bugs.
    '';
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.all;
  };
}
