{ stdenv, lib, fetchFromGitHub, crystal, shards, llvm, which }:

stdenv.mkDerivation {
  pname = "scry";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner  = "crystal-lang-tools";
    repo   = "scry";
    rev    = "543c1c3f764298f9fff192ca884d10f72338607d";
    sha256 = "1yq7jap3y5pr2yqc6fn6bxshzwv7dz3w97incq7wpcvi7ibb4lcn";
  };

  patches = lib.optional (lib.versionAtLeast crystal.version "0.28") ./fix_for_crystal_0_28_and_above.patch;

  nativeBuildInputs = [ crystal shards llvm which ];

  buildPhase = ''
    runHook preBuild

    shards build --release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/scry

    runHook postInstall
  '';

  # https://github.com/crystal-lang-tools/scry/issues/138
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    crystal spec

    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Code analysis server for the Crystal programming language";
    homepage = https://github.com/crystal-lang-tools/scry;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
