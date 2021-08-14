{ rustPlatform, stdenv, lib, fetchFromGitHub, fetchurl
, pkg-config, openssl
, CoreFoundation, libiconv, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.9.2";

  src = stdenv.mkDerivation rec {
    name = "${pname}-source-${version}";

    src = fetchFromGitHub {
      owner = "lu-zero";
      repo = pname;
      rev = "v${version}";
      sha256 = "0hvlrhmbplx4cj4l5fynihgr9cdh0rkpwvipizk1gpp6p1ksr5hz";
    };
    cargoLock = fetchurl {
      url = "https://github.com/lu-zero/${pname}/releases/download/v${version}/Cargo.lock";
      sha256 = "0ckn31asz7013206j153ig96602dxvxm6skdz1plan0h05j5mgah";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "0c0vn2pcy5px02mc0l4a3w7z9n8hc6br5w3ww6nrav5w6911jp52";


  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
  ++ lib.optionals stdenv.isDarwin [ CoreFoundation libiconv Security ];

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
    maintainers = with maintainers; [ ];
  };
}
