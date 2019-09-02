{ stdenv, buildGoPackage, fetchurl
, cmake, xz, which, autoconf
, ncurses6, libedit, libunwind
}:

let
  darwinDeps = [ libunwind libedit ];
  linuxDeps  = [ ncurses6 ];

  buildInputs = if stdenv.isDarwin then darwinDeps else linuxDeps;
  nativeBuildInputs = [ cmake xz which autoconf ];

in
buildGoPackage rec {
  name = "cockroach-${version}";
  version = "2.1.5";

  goPackagePath = "github.com/cockroachdb/cockroach";

  src = fetchurl {
    url = "https://binaries.cockroachdb.com/cockroach-v${version}.src.tgz";
    sha256 = "0bdbkz917175vp28kc513996ik0m61hfbvnqnv0alxv0mfx8djzn";
  };

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

    install -D cockroachoss $bin/bin/cockroach
    install -D cockroach.bash $bin/share/bash-completion/completions/cockroach.bash

    mkdir -p $man/share/man
    cp -r man $man/share/man

    runHook postInstall
  '';

  # Unfortunately we have to keep an empty reference to $out, because it seems
  # buildGoPackages only nukes references to the go compiler under $bin, effectively
  # making all binary output under $bin mandatory. Ideally, we would just use
  # $out and $man and remove $bin since there's no point in an empty path. :(
  outputs = [ "bin" "man" "out" ];

  meta = with stdenv.lib; {
    homepage    = https://www.cockroachlabs.com;
    description = "A scalable, survivable, strongly-consistent SQL database";
    license     = licenses.asl20;
    platforms   = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ rushmorem thoughtpolice ];
  };
}
