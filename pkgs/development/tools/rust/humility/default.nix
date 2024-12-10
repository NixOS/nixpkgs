{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libusb1,
  libftdi,
  cargo-readme,
  pkg-config,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "humility";
  version = "unstable-2023-11-08";

  nativeBuildInputs = [
    pkg-config
    cargo-readme
  ];
  buildInputs =
    [
      libusb1
      libftdi
    ]
    ++ lib.optionals stdenv.isDarwin [
      AppKit
    ];

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = pname;
    rev = "67d932edde8b32c11e5d6356a54e97d65f7b9b2b";
    sha256 = "sha256-3EVNlOAVfx/wUFn83VBKs1N5PanS4jVADUPlhCIok5M=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "capstone-0.10.0" = "sha256-x0p005W6u3QsTKRupj9HEg+dZB3xCXlKb9VCKv+LJ0U=";
      "hidapi-1.4.1" = "sha256-2SBQu94ArGGwPU3wJYV0vwwVOXMCCq+jbeBHfKuE+pA=";
      "hif-0.3.1" = "sha256-o3r1akaSARfqIzuP86SJc6/s0b2PIkaZENjYO3DPAUo=";
      "humpty-0.1.3" = "sha256-efeb+RaAjQs9XU3KkfVo8mVK2dGyv+2xFKSVKS0vyTc=";
      "idol-0.3.0" = "sha256-s6ZM/EyBE1eOySPah5GtT0/l7RIQKkeUPybMmqUpmt8=";
      "idt8a3xxxx-0.1.0" = "sha256-S36fS9hYTIn57Tt9msRiM7OFfujJEf8ED+9R9p0zgK4=";
      "libusb1-sys-0.5.0" = "sha256-7Bb1lpZvCb+OrKGYiD6NV+lMJuxFbukkRXsufaro5OQ=";
      "pmbus-0.1.0" = "sha256-20peEHZl6aXcLhw/OWb4RHAXWRNqoMcDXXglwNP+Gpc=";
      "probe-rs-0.12.0" = "sha256-/L+85K6uxzUmz/TlLLFbMlyekoXC/ClO33EQ/yYjQKU=";
      "spd-0.1.0" = "sha256-X6XUx+huQp77XF5EZDYYqRqaHsdDSbDMK8qcuSGob3E=";
      "tlvc-0.2.0" = "sha256-HiqDRqmKOTxz6UQSXNMOZdWdc5W+cFGuKBkNrqFvIIE=";
      "vsc7448-info-0.1.0" = "sha256-otNLdfGIzuyu03wEb7tzhZVVMdS0of2sU/AKSNSsoho=";
    };
  };

  meta = with lib; {
    description = "Debugger for Hubris";
    mainProgram = "humility";
    homepage = "https://github.com/oxidecomputer/humility";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ therishidesai ];
  };
}
