{ stdenv, fetchFromGitHub, makeWrapper, mono, openssl, ocl-icd }:

stdenv.mkDerivation rec {
  version = "2.1";
  name = "scallion-${version}";

  src = fetchFromGitHub {
    owner = "lachesis";
    repo = "scallion";
    rev = "v${version}";
    sha256 = "1l9aj101xpsaaa6kmmhmq68m6z8gzli1iaaf8xaxbivq0i7vka9k";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ mono ];

  buildPhase = ''
    xbuild scallion.sln
  '';

  installPhase = ''
    mkdir -p $out/share
    cp scallion/bin/Debug/* $out/share/
    makeWrapper ${mono}/bin/mono $out/bin/scallion \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ openssl ocl-icd ]} \
      --add-flags $out/share/scallion.exe
  '';

  meta = with stdenv.lib; {
    description = "GPU-based tor hidden service name generator";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ volth ];
  };
}
