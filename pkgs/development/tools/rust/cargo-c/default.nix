{ rustPlatform, stdenv, lib, fetchFromGitHub, fetchurl
, pkg-config, openssl
, CoreFoundation, libiconv, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.7.0";

  src = stdenv.mkDerivation rec {
    name = "${pname}-source-${version}";

    src = fetchFromGitHub {
      owner = "lu-zero";
      repo = pname;
      rev = "v${version}";
      sha256 = "ckHm95nuDb5WcKBLNz1DWTW/TOt+7nuIq90l4a/doV0=";
    };
    cargoLock = fetchurl {
      url = "https://github.com/lu-zero/${pname}/releases/download/v${version}/Cargo.lock";
      sha256 = "MJlO/RQvxplsfLOUrhtHKlcwdKyykbzdQyLlYWppsIM=";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "mfTP4D1H11NZNA0ZttND6oLzhj7sYZRHdWXpjvIEr6s=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation libiconv Security ];

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
