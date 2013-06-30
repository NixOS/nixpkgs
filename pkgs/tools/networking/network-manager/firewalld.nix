{stdenv, buildPythonPackage, fetchurl, pkgconfig, intltool,
 networkmanager, networkmanagerapplet, ebtables, iptables, gtk3,
 pygobject3, pythonDBus, libnotify, slip}:

buildPythonPackage (rec {
  name = "NetworkManager-${pname}-${version}";
  namePrefix = "";  # We don't want to prefix it with python
  pname = "firewalld";
  version = "0.3.3";

  src = fetchurl {
    url = "http://fedorahosted.org/released/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "3fc9aa4fe177f07167048e50308cfda3875df03a454bab2110f81219fe98362d";
  };

  buildInputs = [ pkgconfig intltool networkmanager networkmanagerapplet ebtables iptables gtk3 ];
  propagatedBuildInputs = [ pygobject3 pythonDBus libnotify slip ];

  preConfigure = ''
    substituteInPlace "src/firewall-applet" \
        --replace "/usr/bin/nm-connection-editor" "${networkmanagerapplet}/bin/nm-connection-editor"
    substituteInPlace "src/firewall-config" \
        --replace "/usr/bin/nm-connection-editor" "${networkmanagerapplet}/bin/nm-connection-editor"
    substituteInPlace "src/firewall/config/__init__.py.in" \
        --replace "/usr/share/" "$out/share/"
    substituteInPlace "src/firewall/core/ebtables.py" \
        --replace "/sbin/ebtables" "${ebtables}/sbin/ebtables"
    substituteInPlace "src/firewall/core/ipXtables.py" \
        --replace "/sbin/iptables" "${iptables}/sbin/iptables"
    substituteInPlace "src/firewall/core/ipXtables.py" \
        --replace "/sbin/ip6tables" "${iptables}/sbin/ip6tables"
  '';

  configureFlags = [
    "--with-systemd-unitdir=$(out)/etc/systemd/system/"
    "--sysconfdir=/etc" "--localstatedir=/var"
  ];

  buildPhase = '''';  # reset to default build phase
  installCommand = ''make install prefix=$out sysconfdir=$out/etc localstatedir=$out/var'';

  # Prefix it with library paths to gtk and libnotify and with gi_typelibs
  postInstall = ''
    for file in "$out"/bin/*; do
      wrapProgram $file \
        --prefix LD_LIBRARY_PATH : ${gtk3}/lib:${libnotify}/lib \
        --suffix-each GI_TYPELIB_PATH ':' "$typelibs"
    done

    mv $out/share/firewalld/gtk3_chooserbutton.py $out/lib/python2.7/site-packages
  '';

  # include inherited and exported typelibs, and make gobject introspection work
  typelibs = map (x: x + x.gi_typelib_path) ([gtk3 libnotify networkmanager] ++
             gtk3.gi_typelib_exports ++ libnotify.gi_typelib_exports);

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://fedoraproject.org/wiki/FirewallD;
    description = "A firewall daemon with D-BUS interface providing a dynamic firewall";
    license = licenses.gpl2;
    maintainers = with maintainers; [ offline];
    platforms = platforms.linux;
  };
})
