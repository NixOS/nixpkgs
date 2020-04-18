{ stdenv, lib, fetchFromGitHub, crystal, shards }:

stdenv.mkDerivation rec {
  pname = "ameba";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner  = "crystal-ameba";
    repo   = "ameba";
    rev    = "v${version}";
    sha256 = "0g68yijbm2j4ig536fwq49d1z7x2iv9kp4g3gjklf5zn1sbqhm12";
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
    homepage = "https://crystal-ameba.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
