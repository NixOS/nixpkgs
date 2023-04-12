{ lib, stdenv, buildGoPackage, fetchurl
, cmake, xz, which, autoconf
, ncurses6, libedit, libunwind
, installShellFiles
, removeReferencesTo, go
}:

let
  darwinDeps = [ libunwind libedit ];
  linuxDeps  = [ ncurses6 ];

  buildInputs = if stdenv.isDarwin then darwinDeps else linuxDeps;
  nativeBuildInputs = [ installShellFiles cmake xz which autoconf ];

in
buildGoPackage rec {
  pname = "cockroach";
  version = "20.1.8";

  goPackagePath = "github.com/cockroachdb/cockroach";

  src = fetchurl {
    url = "https://binaries.cockroachdb.com/cockroach-v${version}.src.tgz";
    sha256 = "0mm3hfr778c7djza8gr1clwa8wca4d3ldh9hlg80avw4x664y5zi";
  };

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [ "-Wno-error=deprecated-copy" "-Wno-error=redundant-move" "-Wno-error=pessimizing-move" ]);

  inherit nativeBuildInputs buildInputs;

  buildPhase = ''
    runHook preBuild
    cd $NIX_BUILD_TOP/go/src/${goPackagePath}
    patchShebangs .
    make buildoss
    cd src/${goPackagePath}
    for asset in man autocomplete; do
      ./cockroachoss gen $asset
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D cockroachoss $out/bin/cockroach
    installShellCompletion cockroach.bash

    mkdir -p $man/share/man
    cp -r man $man/share/man

    runHook postInstall
  '';

  outputs = [ "out" "man" ];

  # fails with `GOFLAGS=-trimpath`
  allowGoReference = true;
  preFixup = ''
    find $out -type f -exec ${removeReferencesTo}/bin/remove-references-to -t ${go} '{}' +
  '';

  meta = with lib; {
    homepage    = "https://www.cockroachlabs.com";
    description = "A scalable, survivable, strongly-consistent SQL database";
    license     = licenses.bsl11;
    platforms   = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ rushmorem thoughtpolice ];
  };
}
