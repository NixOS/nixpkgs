{ lib
, rustPlatform
, fetchCrate
, pkg-config
, curl
, openssl
, stdenv
, CoreFoundation
, libiconv
, Security
, rav1e
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.9.31";

  src = fetchCrate {
    inherit pname;
    # this version may need to be updated along with package version
    version = "${version}+cargo-0.78.0";
    hash = "sha256-RqwUV3e02GykYH/pWHjoent+gix+CD+t3yAQxqUmo54=";
  };

  cargoHash = "sha256-SfKDlcN+PW1twJu3YbmMsQOtFh6JHncAhdrVg+tweAE=";

  nativeBuildInputs = [ pkg-config (lib.getDev curl) ];
  buildInputs = [ openssl curl ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    libiconv
    Security
  ];

  # Ensure that we are avoiding build of the curl vendored in curl-sys
  doInstallCheck = stdenv.hostPlatform.libc == "glibc";
  installCheckPhase = ''
    runHook preInstallCheck

    ldd "$out/bin/cargo-cbuild" | grep libcurl.so

    runHook postInstallCheck
  '';

  passthru.tests = {
    inherit rav1e;
  };

  meta = with lib; {
    description = "A cargo subcommand to build and install C-ABI compatible dynamic and static libraries";
    longDescription = ''
      Cargo C-ABI helpers. A cargo applet that produces and installs a correct
      pkg-config file, a static library and a dynamic library, and a C header
      to be used by any C (and C-compatible) software.
    '';
    homepage = "https://github.com/lu-zero/cargo-c";
    changelog = "https://github.com/lu-zero/cargo-c/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cpu ];
  };
}
