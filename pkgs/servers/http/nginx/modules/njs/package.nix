{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  nixosTests,
  which,
  zlib,
}:

mkNginxPlugin (finalAttrs: {
  pname = "njs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = "njs";
    tag = finalAttrs.version;
    hash = "sha256-svZvAVcIm13SVf4O5rgZOigJ8IKuaPQrnZenkZaDluQ=";
  };

  preConfigure = ''
    configureFlags="''${configureFlags/--add-module=*nginx-mod-${finalAttrs.pname}-${finalAttrs.version}/&/nginx}"

    appendToVar configureFlags "--with-ld-opt=-lz"
  '';

  buildInputs = [
    which
    zlib
  ];

  passthru.tests = nixosTests.nginx-njs;
  meta = {
    description = "Subset of the JavaScript language that allows extending nginx functionality";
    homepage = "https://nginx.org/en/docs/njs/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
})
