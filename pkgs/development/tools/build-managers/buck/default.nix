{ lib, stdenv, fetchFromGitHub, jdk8, ant, python3, watchman, bash, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "buck";
  version = "2022.05.05.01";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "15v4sk1l43pgd5jxr5lxnh0ks6vb3xk5253n66s7vvsnph48j14q";
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
    description = "High-performance build tool";
    mainProgram = "buck";
    maintainers = [ maintainers.jgertm ];
    license = licenses.asl20;
    platforms = platforms.all;
    # https://github.com/facebook/buck/issues/2666
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
