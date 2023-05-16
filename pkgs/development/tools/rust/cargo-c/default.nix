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
<<<<<<< HEAD
, rav1e
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
<<<<<<< HEAD
  version = "0.9.24";
=======
  version = "0.9.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    inherit pname;
    # this version may need to be updated along with package version
<<<<<<< HEAD
    version = "${version}+cargo-0.73.0";
    hash = "sha256-eNaK+SRrHz/DXkCcJP040R6bdhyFmjxkwHbXVFlHub8=";
  };

  cargoHash = "sha256-Us50BbdNSJAx7JTKkvA4tjbGNueCJsAwGEelc1sP5pc=";
=======
    version = "${version}+cargo-0.65";
    sha256 = "sha256-f/p+ZIvDe9JQ8GM82SEud7sRTlimNs/ADPevfdkhsfg=";
  };

  cargoSha256 = "sha256-JrlEWgKbTqQG/JYFqBR53eB58fa29c/+vIdSNGoS5Y0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  passthru.tests = {
    inherit rav1e;
  };

  meta = with lib; {
    description = "A cargo subcommand to build and install C-ABI compatible dynamic and static libraries";
=======
  meta = with lib; {
    description = "A cargo subcommand to build and install C-ABI compatibile dynamic and static libraries";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
