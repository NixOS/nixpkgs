{ rustPlatform, stdenv, lib, fetchFromGitHub, fetchurl
, pkg-config, openssl
, CoreFoundation, libiconv, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.6.13";

  src = stdenv.mkDerivation rec {
    name = "${pname}-source-${version}";

    src = fetchFromGitHub {
      owner = "lu-zero";
      repo = pname;
      rev = "v${version}";
      sha256 = "0ks2w3gclahidv6r6i0d0d6sli7r8wabxzgmhq03czy5w7kr0x56";
    };
    cargoLock = fetchurl {
      url = "https://github.com/lu-zero/${pname}/releases/download/v${version}/Cargo.lock";
      sha256 = "0czy5q8hkjqyn53p7cjxnxfgwygx2a6casjb4nj5gxss2x3haih6";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "0jjkcawcz6wacx22zir9ay1qsi5ffk7c4gwa6jpky4a94zr1h690";

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
