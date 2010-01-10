{stdenv, fetchurl, python, pygobject, pycairo, pyGtkGlade, pythonDBus, 
 wpa_supplicant, dhcp, wirelesstools, nettools, iproute,
 locale ? "C" }:

# Wicd has a ncurses interface that we do not build because it depends
# on urwid which has not been packaged at this time (2009-12-27).

stdenv.mkDerivation rec {
  name = "wicd-1.6.2.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/wicd/files/wicd-stable/${name}/${name}.tar.bz2";
    sha256 = "1gpjrlanz7rrzkchnpm1dgik333rz1fsg4c4046c5pwdfpp1crxr";
  };

  buildInputs = [ python ];

  patches = [ ./no-var-install.patch ./pygtk.patch ./mkdir-networks.patch ];

  # Should I be using pygtk's propogated build inputs?
  postPatch = ''
    sed -i "2iexport PATH=\$PATH\$\{PATH:+:\}${python}/bin:${wpa_supplicant}/sbin:${dhcp}/sbin:${wirelesstools}/sbin:${nettools}/sbin:${iproute}/sbin" in/scripts=wicd.in
    sed -i "3iexport PYTHONPATH=\$PYTHONPATH\$\{PYTHONPATH:+:\}$(toPythonPath $out):$(toPythonPath ${pygobject})/gtk-2.0:$(toPythonPath ${pythonDBus})" in/scripts=wicd.in
    sed -i "4iexport LC_ALL=\\\"${locale}\\\"" in/scripts=wicd.in
    sed -i "2iexport PATH=\$PATH\$\{PATH:+:\}${python}/bin" in/scripts=wicd-client.in
    sed -i "3iexport PYTHONPATH=\$PYTHONPATH\$\{PYTHONPATH:+:\}$(toPythonPath $out):$(toPythonPath ${pyGtkGlade})/gtk-2.0:$(toPythonPath ${pygobject})/gtk-2.0:$(toPythonPath ${pycairo}):$(toPythonPath ${pythonDBus})" in/scripts=wicd-client.in
  '';

  configurePhase = ''
    python setup.py configure \
    --lib=$out/lib/ \
    --etc=/var/lib/wicd/ \
    --share=$out/share/ \
    --scripts=$out/etc/scripts/ \
    --images=$out/share/pixmaps/ \
    --encryption=$out/etc/encryption/templates/ \
    --bin=$out/bin/ \
    --sbin=$out/sbin/ \
    --backends=$out/lib/backends/ \
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

  installPhase = ''python setup.py install --prefix=$out'';

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
    license="GPLv2";
  };
}
