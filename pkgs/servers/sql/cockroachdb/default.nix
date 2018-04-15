{ stdenv, buildGoPackage, fetchurl, go, cmake, which, autoconf, libedit }:

stdenv.mkDerivation rec {
  name = "cockroach-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "https://binaries.cockroachdb.com/cockroach-v${version}.src.tgz";
    sha256 = "0x8hf5qwvgb2w6dcnvy20v77nf19f0l1pb40jf31rm72xhk3bwvy";
  };

  # https://github.com/knz/go-libedit tries to be clever about its
  # dependencies. It bundles its own copy of libedit to avoid an extra
  # dependency on linux, but it uses an external libedit on darwin.
  # For simplicity's sake, just depend on libedit everywhere.
  # Note that if the libedit dependency is changed to be darwin-only,
  # a linux-only dependency on ncurses would need to be added.
  nativeBuildInputs = [ go cmake which autoconf libedit ];

  # Even though we depend on cmake for some bundled dependencies, the
  # top-level build is not cmake and we don't want the cmake
  # configurePhase hooks.
  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make buildoss
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D src/github.com/cockroachdb/cockroach/cockroach $out/bin/cockroach
    $out/bin/cockroach gen man --path=$out/share/man/man1
    install -d $out/share/bash-completion/completions
    $out/bin/cockroach gen autocomplete --out=$out/share/bash-completion/completions/cockroach.bash
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://www.cockroachlabs.com;
    description = "A scalable, survivable, strongly-consistent SQL database";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.rushmorem ];
  };
}
