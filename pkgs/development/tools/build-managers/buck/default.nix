{ stdenv, fetchFromGitHub, jdk, ant, python2, python2Packages, watchman, bash, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "buck";
  version = "2019.05.06.01";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bcj1g8hmcpdgz3c2sxglxxq1jn1x0p9dk6hml8ajkn4h82kw12y";
  };

  patches = [ ./pex-mtime.patch ];

  postPatch = ''
    grep -l -r '/bin/bash' --null | xargs -0 sed -i -e "s!/bin/bash!${bash}/bin/bash!g"
  '';

  buildInputs = [ jdk ant python2 watchman python2Packages.pywatchman ];
  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    ant

    PYTHONDONTWRITEBYTECODE=true ./bin/buck build -c buck.release_version=${version} buck
  '';

  installPhase = ''
    install -D -m755 buck-out/gen/programs/buck.pex $out/bin/buck
    wrapProgram $out/bin/buck \
      --prefix PYTHONPATH : $PYTHONPATH \
      --prefix PATH : "${stdenv.lib.makeBinPath [jdk watchman]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://buckbuild.com/;
    description = "A high-performance build tool";
    maintainers = [ maintainers.jgertm ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
