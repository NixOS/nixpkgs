{ rustPlatform, stdenv, lib, fetchFromGitHub, fetchurl
, pkg-config, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.6.7";

  src = stdenv.mkDerivation rec {
    name = "${pname}-source-${version}";

    src = fetchFromGitHub {
      owner = "lu-zero";
      repo = pname;
      rev = "v${version}";
      sha256 = "0n52xh4qg12bvvp2dgx5wfj5f31qijdqahasa3qfa3c3aqq7cvvg";
    };
    cargoLock = fetchurl {
      url = "https://github.com/lu-zero/${pname}/releases/download/v${version}/Cargo.lock";
      sha256 = "0296187hsaxxmqhsrrva4qf313jwh3z08j1vxcbislxdq8xg32qb";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "1gwyszpcmss2d0lm5hvf3b48jy7b0fm7xizhrl3wd6rzw7pg06zd";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A cargo subcommand to build and install C-ABI compatibile dynamic and static libraries";
    longDescription = ''
      Cargo C-ABI helpers. A cargo applet that produces and installs a correct
      pkg-config file, a static library and a dynamic library, and a C header
      to be used by any C (and C-compatible) software.
    '';
    homepage = "https://github.com/lu-zero/cargo-c";
    changelog = "https://github.com/lu-zero/cargo-c/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
