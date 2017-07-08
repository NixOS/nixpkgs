{ stdenv, fetchFromGitHub, jdk, ant, python2, python2Packages, watchman, unzip, bash, makeWrapper }:

stdenv.mkDerivation rec {
  name = "buck-${version}";
  version = "v2017.05.31.01";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "buck";
    rev = "0b8b3828a11afa79dc128832cb55b106f07e48aa";
    sha256 = "1g3yg8qq91cdhsq7zmir7wxw3767l120f5zhq969gppdw9apqy0s";
  };

  patches = [ ./pex-mtime.patch ];

  postPatch = ''
    grep -l -r '/bin/bash' --null | xargs -0 sed -i -e "s!/bin/bash!${bash}/bin/bash!g"
  '';

  buildInputs = [ jdk ant python2 watchman python2Packages.pywatchman ];
  nativeBuildInputs = [ makeWrapper ];

  targets = [ "buck" "buckd" ];

  buildPhase = ''
    ant

    for exe in ${toString targets}; do
      ./bin/buck build //programs:$exe
    done
  '';

  installPhase = ''
    for exe in ${toString targets}; do
      install -D -m755 buck-out/gen/programs/$exe.pex $out/bin/$exe
      wrapProgram $out/bin/$exe \
        --prefix PYTHONPATH : $PYTHONPATH \
        --prefix PATH : "${stdenv.lib.makeBinPath [jdk watchman]}"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://buckbuild.com/;
    description = "A high-performance build tool";
    maintainers = [ maintainers.jgertm ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
