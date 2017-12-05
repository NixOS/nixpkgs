{stdenv, fetchurl, erlang, pam, perl }:

stdenv.mkDerivation rec {
  name = "yaws-${version}";
  version = "2.0";

  src = fetchurl {
    url = "http://yaws.hyber.org/download/${name}.tar.gz";
    sha256 = "1gwk44a07n7yvg900yrlfc6qpvjl64k2h2hddd1jaaay8lgpcch6";
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
    homepage = http://yaws.hyber.org;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu the-kenny ];
  };

}
