{ stdenv
, cjdns
, nodejs
, makeWrapper
, lib
}:

stdenv.mkDerivation {
  pname = "cjdns-tools";
  version = cjdns.version;

  src = cjdns.src;

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildPhase = ''
    patchShebangs tools

    sed -e "s|'password': 'NONE'|'password': Fs.readFileSync('/etc/cjdns.keys').toString().split('\\\\n').map(v => v.split('=')).filter(v => v[0] === 'CJDNS_ADMIN_PASSWORD').map(v => v[1])[0]|g" \
      -i tools/lib/cjdnsadmin/cjdnsadmin.js
  '';

  installPhase = ''
    mkdir -p $out/bin
    cat ${./wrapper.sh} | sed "s|@@out@@|$out|g" > $out/bin/cjdns-tools
    chmod +x $out/bin/cjdns-tools

    cp -r tools $out/tools
    find $out/tools -maxdepth 1 -type f -exec chmod -v a+x {} \;
    cp -r node_modules $out/node_modules
  '';

  meta = with lib; {
    homepage = "https://github.com/cjdelisle/cjdns";
    description = "Tools for cjdns managment";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "cjdns-tools";
  };
}
