{ stdenv, buildGoPackage, fetchurl, cmake, xz, which }:

buildGoPackage rec {
  name = "cockroach-${version}";
  version = "v1.0.2";

  goPackagePath = "github.com/cockroachdb/cockroach";

  src = fetchurl {
    url = "https://binaries.cockroachdb.com/cockroach-${version}.src.tgz";
    sha256 = "0xq5lg9a2lxn89lilq3zzcd4kph0a5sga3b5bb9xv6af87igy6zp";
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
      mkdir -p $bin/{bin,share,etc/bash_completion.d}
      mv cockroach $bin/bin
      mv man $bin/share
      mv cockroach.bash $bin/etc/bash_completion.d
    '';

  meta = with stdenv.lib; {
    homepage = https://www.cockroachlabs.com;
    description = "A scalable, survivable, strongly-consistent SQL database";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.rushmorem ];
  };
}
