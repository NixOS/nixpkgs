{ stdenv, fetchurl
, openssl, readline, ncurses, zlib
, dataDir ? "/var/lib/softether" }:

stdenv.mkDerivation rec {
  name = "softether-${version}";
  version = "4.29";
  build = "9678";

  src = fetchurl {
    url = "https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v${version}-${build}-rtm/softether-src-v${version}-${build}-rtm.tar.gz";
    sha256 = "11vahid69f3837qpf7yhcfrx24qs2vgd3lbgbali69ksdnzl0dj0";
  };

  buildInputs = [ openssl readline ncurses zlib ];

  preConfigure = ''
      ./configure
  '';

  buildPhase = ''
      mkdir -p $out/bin
      sed -i \
          -e "/INSTALL_BINDIR=/s|/usr/bin|/bin|g" \
          -e "/_DIR=/s|/usr|${dataDir}|g" \
          -e "s|\$(INSTALL|$out/\$(INSTALL|g" \
          -e "/echo/s|echo $out/|echo |g" \
          Makefile

      for f in \
          src/Cedar/Account.c \
          src/Cedar/Account.h \
          src/Cedar/Admin.c \
          src/Cedar/Admin.h \
          src/Cedar/AzureClient.c \
          src/Cedar/AzureClient.h \
          src/Cedar/AzureServer.c \
          src/Cedar/AzureServer.h \
          src/Cedar/Bridge.c \
          src/Cedar/Bridge.h \
          src/Cedar/BridgeUnix.c \
          src/Cedar/BridgeUnix.h \
          src/Cedar/BridgeWin32.c \
          src/Cedar/BridgeWin32.h \
          src/Cedar/Cedar.c \
          src/Cedar/Cedar.h \
          src/Cedar/CedarPch.c \
          src/Cedar/CedarPch.h \
          src/Cedar/CedarType.h \
          src/Cedar/Client.c \
          src/Cedar/Client.h \
          src/Cedar/CM.c \
          src/Cedar/CM.h \
          src/Cedar/CMInner.h \
          src/Cedar/Command.c \
          src/Cedar/Command.h \
          src/Cedar/Connection.c \
          src/Cedar/Connection.h \
          src/Cedar/Console.c \
          src/Cedar/Console.h \
          src/Cedar/Database.c \
          src/Cedar/Database.h \
          src/Cedar/DDNS.c \
          src/Cedar/DDNS.h \
          src/Cedar/EM.c \
          src/Cedar/EM.h \
          src/Cedar/EMInner.h \
          src/Cedar/EtherLog.c \
          src/Cedar/EtherLog.h \
          src/Cedar/Hub.c \
          src/Cedar/Hub.h \
          src/Cedar/Interop_OpenVPN.c \
          src/Cedar/Interop_OpenVPN.h \
          src/Cedar/Interop_SSTP.c \
          src/Cedar/Interop_SSTP.h \
          src/Cedar/IPsec.c \
          src/Cedar/IPsec_EtherIP.c \
          src/Cedar/IPsec_EtherIP.h \
          src/Cedar/IPsec.h \
          src/Cedar/IPsec_IKE.c \
          src/Cedar/IPsec_IKE.h \
          src/Cedar/IPsec_IkePacket.c \
          src/Cedar/IPsec_IkePacket.h \
          src/Cedar/IPsec_IPC.c \
          src/Cedar/IPsec_IPC.h \
          src/Cedar/IPsec_L2TP.c \
          src/Cedar/IPsec_L2TP.h \
          src/Cedar/IPsec_PPP.c \
          src/Cedar/IPsec_PPP.h \
          src/Cedar/IPsec_Win7.c \
          src/Cedar/IPsec_Win7.h \
          src/Cedar/IPsec_Win7Inner.h \
          src/Cedar/Layer3.c \
          src/Cedar/Layer3.h \
          src/Cedar/Link.c \
          src/Cedar/Link.h \
          src/Cedar/Listener.c \
          src/Cedar/Listener.h \
          src/Cedar/Logging.c \
          src/Cedar/Logging.h \
          src/Cedar/Nat.c \
          src/Cedar/Nat.h \
          src/Cedar/NativeStack.c \
          src/Cedar/NativeStack.h \
          src/Cedar/NM.c \
          src/Cedar/NM.h \
          src/Cedar/NMInner.h \
          src/Cedar/NullLan.c \
          src/Cedar/NullLan.h \
          src/Cedar/Protocol.c \
          src/Cedar/Protocol.h \
          src/Cedar/Radius.c \
          src/Cedar/Radius.h \
          src/Cedar/Remote.c \
          src/Cedar/Remote.h \
          src/Cedar/Sam.c \
          src/Cedar/Sam.h \
          src/Cedar/SecureInfo.c \
          src/Cedar/SecureInfo.h \
          src/Cedar/SecureNAT.c \
          src/Cedar/SecureNAT.h \
          src/Cedar/SeLowUser.c \
          src/Cedar/SeLowUser.h \
          src/Cedar/Server.c \
          src/Cedar/Server.h \
          src/Cedar/Session.c \
          src/Cedar/Session.h \
          src/Cedar/SM.c \
          src/Cedar/SM.h \
          src/Cedar/SMInner.h \
          src/Cedar/SW.c \
          src/Cedar/SW.h \
          src/Cedar/SWInner.h \
          src/Cedar/UdpAccel.c \
          src/Cedar/UdpAccel.h \
          src/Cedar/UT.c \
          src/Cedar/UT.h \
          src/Cedar/VG.c \
          src/Cedar/VG.h \
          src/Cedar/Virtual.c \
          src/Cedar/Virtual.h \
          src/Cedar/VLan.c \
          src/Cedar/VLan.h \
          src/Cedar/VLanUnix.c \
          src/Cedar/VLanUnix.h \
          src/Cedar/VLanWin32.c \
          src/Cedar/VLanWin32.h \
          src/Cedar/WaterMark.c \
          src/Cedar/WaterMark.h \
          src/Cedar/WebUI.c \
          src/Cedar/WebUI.h \
          src/Cedar/Win32Com.cpp \
          src/Cedar/Win32Com.h \
          src/Cedar/WinJumpList.cpp \
          src/Cedar/WinUi.c \
          src/Cedar/WinUi.h \
          src/Cedar/Wpc.c \
          src/Cedar/Wpc.h \
          src/GlobalConst.h \
          src/hamcorebuilder/hamcorebuilder.c \
          src/Mayaqua/Cfg.c \
          src/Mayaqua/Cfg.h \
          src/Mayaqua/Encrypt.c \
          src/Mayaqua/Encrypt.h \
          src/Mayaqua/FileIO.c \
          src/Mayaqua/FileIO.h \
          src/Mayaqua/Internat.c \
          src/Mayaqua/Internat.h \
          src/Mayaqua/Kernel.c \
          src/Mayaqua/Kernel.h \
          src/Mayaqua/Mayaqua.c \
          src/Mayaqua/Mayaqua.h \
          src/Mayaqua/MayaType.h \
          src/Mayaqua/Memory.c \
          src/Mayaqua/Memory.h \
          src/Mayaqua/Microsoft.c \
          src/Mayaqua/Microsoft.h \
          src/Mayaqua/Network.c \
          src/Mayaqua/Network.h \
          src/Mayaqua/Object.c \
          src/Mayaqua/Object.h \
          src/Mayaqua/OS.c \
          src/Mayaqua/OS.h \
          src/Mayaqua/Pack.c \
          src/Mayaqua/Pack.h \
          src/Mayaqua/Secure.c \
          src/Mayaqua/Secure.h \
          src/Mayaqua/Str.c \
          src/Mayaqua/Str.h \
          src/Mayaqua/Table.c \
          src/Mayaqua/Table.h \
          src/Mayaqua/TcpIp.c \
          src/Mayaqua/TcpIp.h \
          src/Mayaqua/Tick64.c \
          src/Mayaqua/Tick64.h \
          src/Mayaqua/Tracking.c \
          src/Mayaqua/Tracking.h \
          src/Mayaqua/Unix.c \
          src/Mayaqua/Unix.h \
          src/Mayaqua/Win32.c \
          src/Mayaqua/Win32.h \
          src/vpnbridge/vpnbridge.c \
          src/vpnclient/vpncsvc.c \
          src/vpncmd/vpncmd.c \
          src/vpncmdsys/vpncmdsys.c \
          src/vpncmdsys/vpncmdsys.h \
          src/vpncmgr/vpncmgr.c \
          src/vpndrvinst/vpndrvinst.c \
          src/vpndrvinst/vpndrvinst.h \
          src/vpninstall/vpninstall.c \
          src/vpninstall/vpninstall.h \
          src/vpnserver/vpnserver.c \
          src/vpnsetup/vpnsetup.c \
      ; do
        sed -i \
            -e "/^Copyright/s|^Copyright|// Copyright|g" \
            $f
      done
  '';

  meta = with stdenv.lib; {
    description = "An Open-Source Free Cross-platform Multi-protocol VPN Program";
    homepage = https://www.softether.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.rick68 ];
    platforms = filter (p: p != "aarch64-linux") platforms.linux;
  };
}
