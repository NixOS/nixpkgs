{ lib, stdenv, fetchFromGitHub, jdk8, ant, python3, watchman, bash, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "buck";
  version = "2021.01.12.01";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NFiMQ+cG93R10LlkfUMzZ4TnV0uO5G+8S5TiMI6hU5o=";
  };

  patches = [ ./pex-mtime.patch ];

  postPatch = ''
    grep -l -r '/bin/bash' --null | xargs -0 sed -i -e "s!/bin/bash!${bash}/bin/bash!g"
  '';

  nativeBuildInputs = [ makeWrapper python3 jdk8 ant watchman ];

  buildPhase = ''
    # Set correct version, see https://github.com/facebook/buck/issues/2607
    echo v${version} > .buckrelease

    ant

    PYTHONDONTWRITEBYTECODE=true ./bin/buck build -c buck.release_version=${version} buck
  '';

  installPhase = ''
    install -D -m755 buck-out/gen/*/programs/buck.pex $out/bin/buck
    wrapProgram $out/bin/buck \
      --prefix PATH : "${lib.makeBinPath [ jdk8 watchman python3 ]}"
  '';

  meta = with lib; {
    homepage = "https://buck.build/";
    description = "A high-performance build tool";
    maintainers = [ maintainers.jgertm maintainers.marsam ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
