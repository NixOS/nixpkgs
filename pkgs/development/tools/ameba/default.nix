{ stdenv, lib, fetchFromGitHub, crystal, shards }:

stdenv.mkDerivation {
  pname = "ameba";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner  = "crystal-ameba";
    repo   = "ameba";
    rev    = "v0.10.1";
    sha256 = "0dcw7px7g0c5pxpdlirhirqzhcc7gdwdfiwb9kgm4x1k74ghjgxq";
  };

  nativeBuildInputs = [ crystal shards ];

  buildPhase = ''
    runHook preBuild
    shards build --release
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin bin/ameba
    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    crystal spec
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "A static code analysis tool for Crystal";
    homepage = https://crystal-ameba.github.io;
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
