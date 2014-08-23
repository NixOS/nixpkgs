{stdenv, fetchurl, erlang, pam, perl }:

stdenv.mkDerivation rec {
  name = "yaws-${version}";
  version = "1.98";

  src = fetchurl {
    url = "http://yaws.hyber.org/download/${name}.tar.gz";
    sha256 = "0c88da7gxha7an3c82j5a3r1y0j7cjq66zqfrzjihg8pwp618zfl";
  };

  # The tarball includes a symlink yaws -> yaws-1.95, which seems to be
  # necessary for importing erlang files
  unpackPhase = ''
    tar xzf $src
    cd $name
  '';

  configureFlags = "--with-extrainclude=${pam}/include/security";

  buildInputs = [ erlang pam perl ];

  postInstall = ''
    sed -i "s#which #type -P #" $out/bin/yaws
  '';

  meta = with stdenv.lib; {
    description = "A high performance HTTP 1.1 server in Erlang";
    homepage = http://http://yaws.hyber.org;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu the-kenny ];
  };

}
