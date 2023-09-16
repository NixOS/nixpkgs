{ lib, stdenv, fetchgit, cmake, postgresql, nixosTests }:

stdenv.mkDerivation (finalAttrs: {
  pname = "lantern";
  version = "0.0.4";

  src = fetchgit {
    url = "https://github.com/lanterndata/lantern.git";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-SaRWJxM/Mi9eflT8C7LA987ItQRCKKES+hlhy9QXSV4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib lantern.so
    install -D -t $out/share/postgresql/extension lantern-*.sql
    install -D -t $out/share/postgresql/extension lantern.control
  '';

  passthru.tests.lantern = nixosTests.lantern;

  meta = with lib; {
    description = "Open-source PostgreSQL database extension to store vector data, generate embeddings, and handle vector search operations.";
    homepage = "https://github.com/lanterndata/lantern";
    changelog = "https://github.com/lanterndata/lantern/blob/main/CHANGELOG.md";
    license = licenses.mit;
    platforms = postgresql.meta.platforms;
    broken = (stdenv.system == "x86_64-darwin"); # Dependencies use functions not available until mcOS 10.15
    maintainers = [ maintainers.moody ];
  };
})
