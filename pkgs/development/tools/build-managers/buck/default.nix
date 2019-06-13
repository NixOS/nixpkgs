{ stdenv, fetchFromGitHub, jdk, ant, python2, python2Packages, watchman, bash, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "buck";
  version = "2019.05.22.01";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fxprw18kd3cw1lzv4xi1lnbdni06hs4vm9yh0w548rsfn3wnmxq";
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
