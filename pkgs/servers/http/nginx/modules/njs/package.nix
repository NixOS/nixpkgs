{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  nixosTests,
  quickjs,
  which,
  zlib,
}:

mkNginxPlugin (finalAttrs: {
  pname = "njs";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = "njs";
    tag = finalAttrs.version;
    hash = "sha256-W30H50g9i3zSpSWDWm24MpZRCy+/RAVgoHDbYJJvr0U=";
  };

  preConfigure = ''
    configureFlags="''${configureFlags/--add-module=*nginx-mod-${finalAttrs.pname}-${finalAttrs.version}/&/nginx}"

    appendToVar configureFlags "--with-ld-opt=-lz"
    appendToVar configureFlags "--with-cc-opt=-I${lib.getInclude quickjs}/include/quickjs"
    appendToVar configureFlags "--with-ld-opt=-L${lib.getLib quickjs}/lib/quickjs"
  '';

  buildInputs = [
    quickjs
    which
    zlib
  ];

  passthru.tests = nixosTests.nginx.stable.njs;
  meta = {
    description = "Subset of the JavaScript language that allows extending nginx functionality";
    homepage = "https://nginx.org/en/docs/njs/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
})
