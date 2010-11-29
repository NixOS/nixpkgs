{stdenv, fetchurl, python, pygobject, pycairo, pyGtkGlade, pythonDBus, 
 wpa_supplicant, dhcp, wirelesstools, nettools, iproute,
 locale ? "C" }:

# Wicd has a ncurses interface that we do not build because it depends
# on urwid which has not been packaged at this time (2009-12-27).

stdenv.mkDerivation rec {
  name = "wicd-1.7.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/project/wicd/wicd-stable/${name}/${name}.tar.bz2";
    sha256 = "0civfmpjlsvnaiw7fkpq34mh5ndhfzb9mkl3q2d3rjd4z0mnki8l";
  };

  buildInputs = [ python ];

  patches = [ ./no-var-install.patch ./pygtk.patch ./mkdir-networks.patch ];

  # Should I be using pygtk's propogated build inputs?
  postPatch = ''
    substituteInPlace in/scripts=wicd.in --subst-var-by TEMPLATE-DEFAULT $out/share/other/dhclient.conf.template.default
    sed -i "2iexport PATH=\$PATH\$\{PATH:+:\}${python}/bin:${wpa_supplicant}/sbin:${dhcp}/sbin:${wirelesstools}/sbin:${nettools}/sbin:${iproute}/sbin" in/scripts=wicd.in
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
    --varlib=$out/share/ \
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
    ensureDir $out/share/other
    cp other/dhclient.conf.template.default $out/share/other/dhclient.conf.template.default
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
