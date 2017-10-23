{ stdenv, buildGoPackage, fetchurl, cmake, xz, which, autoconf }:

buildGoPackage rec {
  name = "cockroach-${version}";
  version = "v1.1.1";

  goPackagePath = "github.com/cockroachdb/cockroach";

  src = fetchurl {
    url = "https://binaries.cockroachdb.com/cockroach-${version}.src.tgz";
    sha256 = "0d2nlm291k4x7hqi0kh76j6pj8b1dwbdww5f95brf0a9bl1n7qxr";
  };

  nativeBuildInputs = [ cmake xz which autoconf ];

  buildPhase =
    ''
      cd $NIX_BUILD_TOP/go/src/${goPackagePath}
      patchShebangs ./
      make buildoss
      cd src/${goPackagePath}
      for asset in man autocomplete; do
        ./cockroach gen $asset
      done
    '';

  installPhase =
    ''
      mkdir -p $bin/{bin,share}
      mv cockroach $bin/bin/
      mv man $bin/share/

      mkdir -p $out/share/bash-completion/completions
      mv cockroach.bash $out/share/bash-completion/completions
    '';

  meta = with stdenv.lib; {
    homepage = https://www.cockroachlabs.com;
    description = "A scalable, survivable, strongly-consistent SQL database";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.rushmorem ];
  };
}
