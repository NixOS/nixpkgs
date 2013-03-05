{stdenv, fetchurl, python, pygobject, pycairo, pyGtkGlade, pythonDBus, 
 wpa_supplicant, dhcp, dhcpcd, wirelesstools, nettools, openresolv, iproute,
 locale ? "C" }:

# Wicd has a ncurses interface that we do not build because it depends
# on urwid which has not been packaged at this time (2009-12-27).

stdenv.mkDerivation rec {
  name = "wicd-1.7.1-beta2";
  
  src = fetchurl {
    url = "mirror://sourceforge/wicd/wicd-1.7.1b2.tar.bz2";
    sha256 = "13ga6a2ip8dy8h49wvv02jxxfvpk5q5sm2wz76dy62y1xsrm23c1";
  };

  buildInputs = [ python ];

  patches = [ ./no-var-install.patch ./mkdir-networks.patch ./pygtk.patch ./no-optimization.patch ];

  # Should I be using pygtk's propogated build inputs?
  # !!! Should use makeWrapper.
  postPatch = ''
    # We don't have "python2".
    substituteInPlace wicd/wicd-daemon.py --replace 'misc.find_path("python2")' "'${python}/bin/python'"
    
    substituteInPlace in/scripts=wicd.in --subst-var-by TEMPLATE-DEFAULT $out/share/other/dhclient.conf.template.default
    
    sed -i "2iexport PATH=\$PATH\$\{PATH:+:\}${python}/bin:${wpa_supplicant}/sbin:${dhcpcd}/sbin:${dhcp}/sbin:${wirelesstools}/sbin:${nettools}/sbin:${openresolv}/sbin:${iproute}/sbin" in/scripts=wicd.in
    sed -i "3iexport PYTHONPATH=\$PYTHONPATH\$\{PYTHONPATH:+:\}$(toPythonPath $out):$(toPythonPath ${pygobject})/gtk-2.0:$(toPythonPath ${pythonDBus})" in/scripts=wicd.in
    sed -i "4iexport LC_ALL=\\\"${locale}\\\"" in/scripts=wicd.in
    sed -i "2iexport PATH=\$PATH\$\{PATH:+:\}${python}/bin" in/scripts=wicd-client.in
    sed -i "3iexport PYTHONPATH=\$PYTHONPATH\$\{PYTHONPATH:+:\}$(toPythonPath $out):$(toPythonPath ${pyGtkGlade})/gtk-2.0:$(toPythonPath ${pygobject})/gtk-2.0:$(toPythonPath ${pycairo}):$(toPythonPath ${pythonDBus})" in/scripts=wicd-client.in
    sed -i "2iexport PATH=\$PATH\$\{PATH:+:\}${python}/bin" in/scripts=wicd-gtk.in
    sed -i "3iexport PYTHONPATH=\$PYTHONPATH\$\{PYTHONPATH:+:\}$(toPythonPath $out):$(toPythonPath ${pyGtkGlade})/gtk-2.0:$(toPythonPath ${pygobject})/gtk-2.0:$(toPythonPath ${pycairo}):$(toPythonPath ${pythonDBus})" in/scripts=wicd-gtk.in
    sed -i "2iexport PATH=\$PATH\$\{PATH:+:\}${python}/bin" in/scripts=wicd-cli.in
    sed -i "3iexport PYTHONPATH=\$PYTHONPATH\$\{PYTHONPATH:+:\}$(toPythonPath $out):$(toPythonPath ${pyGtkGlade})/gtk-2.0:$(toPythonPath ${pygobject})/gtk-2.0:$(toPythonPath ${pycairo}):$(toPythonPath ${pythonDBus})" in/scripts=wicd-cli.in
  '';

  configurePhase = ''
    python setup.py configure \
    --lib=$out/lib/ \
    --share=$out/share/ \
    --etc=/var/lib/wicd/ \
    --scripts=$out/etc/scripts/ \
    --pixmaps=$out/share/pixmaps/ \
    --images=$out/share/pixmaps/wicd/ \
    --encryption=$out/etc/encryption/templates/ \
    --bin=$out/bin/ \
    --sbin=$out/sbin/ \
    --backends=$out/share/backends/ \
    --daemon=$out/share/daemon/ \
    --curses=$out/share/curses/ \
    --gtk=$out/share/gtk/ \
    --cli=$out/share/cli/ \
    --networks=/var/lib/wicd/configurations/ \
    --resume=$out/etc/acpi/resume.d/ \
    --suspend=$out/etc/acpi/suspend.d/ \
    --pmutils=$out/lib/pm-utils/sleep.d/ \
    --dbus=$out/etc/dbus-1/system.d/ \
    --desktop=$out/share/applications/ \
    --icons=$out/share/icons/hicolour/ \
    --translations=$out/share/locale/ \
    --autostart=$out/etc/xdg/autostart/ \
    --varlib=/var/lib/wicd/ \
    --docdir=$out/share/doc/ \
    --mandir=$out/share/man/ \
    --kdedir=$out/share/autostart/ \
    --python=${python}/bin/python \
    --distro=nix \
    --wicdgroup=users \
    --no-install-init \
    --no-install-kde \
    --no-install-acpi \
    --no-install-pmutils \
    --no-install-ncurses \
  '';

  installPhase = ''
    python setup.py install --prefix=$out
    mkdir -p $out/share/other
    cp other/dhclient.conf.template.default $out/share/other/dhclient.conf.template.default

    # Add a template for "WPA2 Enterprise" encryption as used, e.g., by the
    # Eduroam network.  Taken and adapted from
    # <http://wicd.net/punbb/viewtopic.php?id=87>.
    cp -v "${./wpa2-ttls}" "$out/etc/encryption/templates/wpa2-ttls"
    echo "wpa2-ttls" >> "$out/etc/encryption/templates/active"

    # have wicd generate upstart events
    echo '#!/bin/sh
initctl emit -n wicd-preconnect ITYPE="$1" ESSID="$2" BSSID="$3"' > $out/etc/scripts/preconnect/upstart-emit
    echo '#!/bin/sh
initctl emit -n wicd-postconnect ITYPE="$1" ESSID="$2" BSSID="$3"
initctl emit -n ip-up' > $out/etc/scripts/postconnect/upstart-emit
    echo '#!/bin/sh
initctl emit -n wicd-predisconnect ITYPE="$1" ESSID="$2" BSSID="$3"' > $out/etc/scripts/predisconnect/upstart-emit
    echo '#!/bin/sh
initctl emit -n wicd-postdisconnect ITYPE="$1" ESSID="$2" BSSID="$3"
initctl emit -n ip-down' > $out/etc/scripts/postdisconnect/upstart-emit
    chmod a+x $out/etc/scripts/*/upstart-emit
  '';

  meta = {
    homepage = http://wicd.net/;
    description = "A wiredless and wired network manager";
    longDescription=''
      A complete network connection manager
      Wicd supports wired and wireless networks, and capable of
      creating and tracking profiles for both.  It has a
      template-based wireless encryption system, which allows the user
      to easily add encryption methods used.  It ships with some common
      encryption types, such as WPA and WEP. Wicd will automatically
      connect at startup to any preferred network within range.
    '';
    maintainers = [ stdenv.lib.maintainers.roconnor ];
    license="GPLv2";
  };
}
