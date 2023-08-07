{ autoconf
, automake
, bash
, cacert
, cmake
, cmakerc
, coreutils
, curl
, fetchFromGitHub
, fmt
, gcc
, git
, gnumake
, gzip
, lib
, makeWrapper
, meson
, ninja
, perl
, pkg-config
, python3
, stdenv
, zip
, zstd
}:
let
  # These are the most common binaries used by vcpkg
  # If a port requires a binary that is not in this list,
  # it can be added by an overlay
  runtimeDeps = [
    autoconf
    automake
    bash
    cacert
    coreutils
    curl
    cmake
    gcc
    git
    gnumake
    gzip
    meson
    ninja
    perl
    pkg-config
    python3
    zip
    zstd
  ];
in
stdenv.mkDerivation {
  pname = "vcpkg-tool";
  version = "2023-08-02";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg-tool";
    rev = "2023-08-02";
    hash = "sha256-HlmqJ/rRlfRR6tJNJVaCcwdQmNboMNsXbuJ1LepfdOQ=";
  };

  nativeBuildInputs = [
    cmake
    cmakerc
    fmt
    ninja
    makeWrapper
  ];

  cmakeFlags = [
    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON"
    "-DVCPKG_DEPENDENCY_CMAKERC=ON"
  ];

  postFixup = ''
    # add the runtime dependencies to the PATH
    wrapProgram $out/bin/vcpkg --set PATH ${lib.makeBinPath runtimeDeps}
  '';

  meta = with lib; {
    description = "Components of microsoft/vcpkg's binary.";
    homepage = "https://github.com/microsoft/vcpkg-tool";
    license = licenses.mit;
    maintainers = with maintainers; [ guekka gracicot ];
  };
}
