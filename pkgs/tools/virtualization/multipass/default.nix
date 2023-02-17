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
  version = "1.11.1";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "multipass";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-AIZs+NRAn/r9EjTx9InDZzS4ycni4MZQXmC0A5rpaJk=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    substituteInPlace ./CMakeLists.txt \
      --replace "determine_version(MULTIPASS_VERSION)" "" \
      --replace 'set(MULTIPASS_VERSION ''${MULTIPASS_VERSION})' 'set(MULTIPASS_VERSION "v${version}")'

    substituteInPlace ./src/platform/backends/qemu/linux/qemu_platform_detail_linux.cpp \
      --replace "OVMF.fd" "${OVMF.fd}/FV/OVMF.fd" \
      --replace "QEMU_EFI.fd" "${OVMF.fd}/FV/QEMU_EFI.fd"
  '';

  postPatch = ''
    # Patch all of the places where Multipass expects the LXD socket to be provided by a snap
    substituteInPlace ./src/network/network_access_manager.cpp \
      --replace "/var/snap/lxd/common/lxd/unix.socket" "/var/lib/lxd/unix.socket"

    substituteInPlace ./src/platform/backends/lxd/lxd_virtual_machine.cpp \
      --replace "/var/snap/lxd/common/lxd/unix.socket" "/var/lib/lxd/unix.socket"

    substituteInPlace ./src/platform/backends/lxd/lxd_request.h \
      --replace "/var/snap/lxd/common/lxd/unix.socket" "/var/lib/lxd/unix.socket"

    substituteInPlace ./tests/CMakeLists.txt \
      --replace "FetchContent_MakeAvailable(googletest)" ""

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
