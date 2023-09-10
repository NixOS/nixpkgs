{ cmake
, dnsmasq
, fetchFromGitHub
, git
, gtest
, iproute2
, iptables
, lib
, libapparmor
, libvirt
, libxml2
, nixosTests
, openssl
, OVMF
, pkg-config
, qemu
, qemu-utils
, qtbase
, qtx11extras
, slang
, stdenv
, wrapQtAppsHook
, xterm
}:

let
  pname = "multipass";
  version = "1.12.1";

  # This is done here because a CMakeLists.txt from one of it's submodules tries
  # to modify a file, so we grab the source for the submodule here, copy it into
  # the source of the Multipass project which allows the modification to happen.
  grpc_src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = "grpc";
    rev = "ba8e7f72a57b9e0b25783a4d3cea58c79379f194";
    hash = "sha256-DS1UNLCUdbipn5w4p2aVa8LgHHhdJiAfzfEdIXNO69o=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation
{
  inherit pname version;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "multipass";
    rev = "refs/tags/v${version}";
    hash = "sha256-8wRho/ECWxiE6rNqjBzaqFaIdhXzOzFuCcQ4zzfSmb4=";
    fetchSubmodules = true;
  };

  patches = [
    ./lxd_socket_path.patch
    ./cmake_no_fetch.patch
  ];

  postPatch = ''
    # Make sure the version is reported correctly in the compiled binary.
    substituteInPlace ./CMakeLists.txt \
      --replace "determine_version(MULTIPASS_VERSION)" "" \
      --replace 'set(MULTIPASS_VERSION ''${MULTIPASS_VERSION})' 'set(MULTIPASS_VERSION "v${version}")'

    # Patch the patch of the OVMF binaries to use paths from the nix store.
    substituteInPlace ./src/platform/backends/qemu/linux/qemu_platform_detail_linux.cpp \
      --replace "OVMF.fd" "${OVMF.fd}/FV/OVMF.fd" \
      --replace "QEMU_EFI.fd" "${OVMF.fd}/FV/QEMU_EFI.fd"

    # Copy the grpc submodule we fetched into the source code.
    cp -r --no-preserve=mode ${grpc_src} 3rd-party/grpc

    # Configure CMake to use gtest from the nix store since we disabled fetching from the internet.
    cat >> tests/CMakeLists.txt <<'EOF'
      add_library(gtest INTERFACE)
      target_include_directories(gtest INTERFACE ${gtest.dev}/include)
      target_link_libraries(gtest INTERFACE ${gtest}/lib/libgtest.so ''${CMAKE_THREAD_LIBS_INIT})
      add_dependencies(gtest GMock)

      add_library(gtest_main INTERFACE)
      target_include_directories(gtest_main INTERFACE ${gtest.dev}/include)
      target_link_libraries(gtest_main INTERFACE ${gtest}/lib/libgtest_main.so gtest)

      add_library(gmock INTERFACE)
      target_include_directories(gmock INTERFACE ${gtest.dev}/include)
      target_link_libraries(gmock INTERFACE ${gtest}/lib/libgmock.so gtest)

      add_library(gmock_main INTERFACE)
      target_include_directories(gmock_main INTERFACE ${gtest.dev}/include)
      target_link_libraries(gmock_main INTERFACE ${gtest}/lib/libgmock_main.so gmock gtest_main)
    EOF
  '';

  buildInputs = [
    gtest
    libapparmor
    libvirt
    libxml2
    openssl
    qtbase
    qtx11extras
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    slang
    wrapQtAppsHook
  ];

  nativeCheckInputs = [ gtest ];

  postInstall = ''
    wrapProgram $out/bin/multipassd --prefix PATH : ${lib.makeBinPath [
      dnsmasq
      iproute2
      iptables
      OVMF.fd
      qemu
      qemu-utils
      xterm
    ]}
  '';

  passthru.tests = {
    multipass = nixosTests.multipass;
  };

  meta = with lib; {
    description = "Ubuntu VMs on demand for any workstation.";
    homepage = "https://multipass.run";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jnsgruk ];
    platforms = [ "x86_64-linux" ];
  };
}
