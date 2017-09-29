{ stdenv, buildGoPackage, fetchurl, cmake, xz, which }:

buildGoPackage rec {
  name = "cockroach-${version}";
  version = "v1.0.5";

  goPackagePath = "github.com/cockroachdb/cockroach";

  src = fetchurl {
    url = "https://binaries.cockroachdb.com/cockroach-${version}.src.tgz";
    sha256 = "0jjl6zb8pyxws3i020h98vdr217railca8h6n3xijkvcqy9dj8wa";
  };

  buildInputs = [ cmake xz which ];

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
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.rushmorem ];
  };
}
