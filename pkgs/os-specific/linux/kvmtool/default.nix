{ stdenv, fetchgit, libbfd, zlib, libaio, glibc }:

stdenv.mkDerivation {
  name = "kvmtool";
  version = "unstable-2020-05-19";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    rev = "b4fc4f605fc66a0942e88f37b3a4b18671e32b0c";
    sha256 = "0kyb3rm98wzwgjs06crcgb39547rr4px4vap8ivm7yqnwbphr67f";
  };

  buildInputs = [ libbfd zlib libaio glibc glibc.static];

  buildPhase = ''
    make all
  '';
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    description = "Native Linux KVM tool";
    longDescription = ''
      kvmtool is a lightweight tool for hosting KVM guests. As a pure virtualization
      tool it only supports guests using the same architecture, though it supports
      running 32-bit guests on those 64-bit architectures that allow this.

      From the original announcement email:
      -------------------------------------------------------
      The goal of this tool is to provide a clean, from-scratch, lightweight
      KVM host tool implementation that can boot Linux guest images (just a
      hobby, won't be big and professional like QEMU) with no BIOS
      dependencies and with only the minimal amount of legacy device
      emulation.

      It's great as a learning tool if you want to get your feet wet in
      virtualization land: it's only 5 KLOC of clean C code that can already
      boot a guest Linux image.

      Right now it can boot a Linux image and provide you output via a serial
      console, over the host terminal, i.e. you can use it to boot a guest
      Linux image in a terminal or over ssh and log into the guest without
      much guest or host side setup work needed.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ zokrezyl ];
    platforms = platforms.linux;
  };
}
