{ lib
, rustPlatform
, fetchCrate
, pkg-config
, zlib
, curl
, libssh2
, openssl
, stdenv
, CoreFoundation
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.9.13";

  src = fetchCrate {
    inherit pname;
    # this version may need to be updated along with package version
    version = "${version}+cargo-0.65";
    sha256 = "sha256-f/p+ZIvDe9JQ8GM82SEud7sRTlimNs/ADPevfdkhsfg=";
  };

  cargoSha256 = "sha256-JrlEWgKbTqQG/JYFqBR53eB58fa29c/+vIdSNGoS5Y0=";

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ pkg-config (lib.getDev curl) (lib.getDev libssh2) zlib ];
  buildInputs = [ openssl curl libssh2 stdenv.cc.cc.lib ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    libiconv
    Security
  ];
  NIX_LDFLAGS = "-lc -lm -lgcc ";
  LIBSSH2_SYS_USE_PKG_CONFIG = "1";

  # Ensure that we are avoiding build of the curl vendored in curl-sys
  doInstallCheck = stdenv.hostPlatform.libc == "glibc";
  installCheckPhase = ''
    runHook preInstallCheck

    ldd "$out/bin/cargo-cbuild" | grep libcurl.so

    runHook postInstallCheck
  '';

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
    maintainers = with maintainers; [ ];
  };
}
