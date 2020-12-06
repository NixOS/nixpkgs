{ rustPlatform, stdenv, lib, fetchFromGitHub, fetchurl
, pkg-config, openssl
, CoreFoundation, libiconv, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.6.18";

  src = stdenv.mkDerivation rec {
    name = "${pname}-source-${version}";

    src = fetchFromGitHub {
      owner = "lu-zero";
      repo = pname;
      rev = "v${version}";
      sha256 = "1dh5z210nl8grjxb8zxch8h7799w61bah7r2j0s07091rcpfsrsb";
    };
    cargoLock = fetchurl {
      url = "https://github.com/lu-zero/${pname}/releases/download/v${version}/Cargo.lock";
      sha256 = "1h5wmfmm2a2ilyw3ar88rqm7yvdc2vhyx4pgg781615ax52fhjli";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "0ll9p2rbnw46zd9m2bmdmn99v9jjjf8i33xpkvd1rx42ki7sys62";

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
