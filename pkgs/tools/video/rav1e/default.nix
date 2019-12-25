{ rustPlatform, fetchFromGitHub, fetchurl, stdenv, lib, unzip, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.2.0";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "0sij9hwnar27gcwvfcjbhgyrhw99zjv8gr9s9gshqi766p5dy51a";
    };
    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v${version}/rav1e-${version}.zip";
      sha256 = "1i48c7mvc9q20d76p2rpxva551249m3p52q2z1g9sj4xzpyyk41m";
    };

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      unzip ${cargoLock}
      cp ./Cargo.lock $out/Cargo.lock
    '';
  };

  cargoSha256 = "1z0xrcq4mx6gpjyqh1csa424sxmx54z3x7ij3w2063h6s2fv9jy3";

  nativeBuildInputs = [ nasm ];

  meta = with lib; {
    description = "The fastest and safest AV1 encoder";
    longDescription = ''
      rav1e is an AV1 video encoder. It is designed to eventually cover all use
      cases, though in its current form it is most suitable for cases where
      libaom (the reference encoder) is too slow.
      Features: https://github.com/xiph/rav1e#features
    '';
    inherit (src.src.meta) homepage;
    license = licenses.bsd2;
    maintainers = [ maintainers.primeos ];
    platforms = platforms.all;
  };
}
