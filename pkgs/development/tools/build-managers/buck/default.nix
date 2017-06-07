  { stdenv, pkgs, fetchFromGitHub, fetchgit, jdk, ant, python2, watchman, unzip, bash }:

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
    for f in $(grep -l -r '/bin/bash'); do
      substituteInPlace "$f" --replace '/bin/bash' '${bash}/bin/bash'
    done
  '';

  buildInputs = [ jdk ant ];

  propagatedBuildInputs = [ python2 watchman pkgs.python27Packages.pywatchman ];

  buildPhase =
    ''
      ant
      ./bin/buck --version
      ./bin/buck build buck
    '';

  installPhase =
    ''
      mkdir -p $out/bin
      cp  buck-out/gen/programs/buck.pex $out/bin/buck
    '';

  meta = with stdenv.lib; {
    homepage = https://buckbuild.com/;
    description = "A high-performance build tool";
    maintainers = [ maintainers.jgertm ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
