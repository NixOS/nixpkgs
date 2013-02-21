{stdenv, fetchurl, erlang, pam, perl }:

stdenv.mkDerivation rec {
  name = "yaws-${version}";
  version = "1.95";

  src = fetchurl {
    url = "http://yaws.hyber.org/download/${name}.tar.gz";
    sha256 = "01jlp6v8l95n9k5rbp4kvklnh95q7yv9lp2a6ahyixb1cn1sxvz4";
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
    maintainers = [ maintainers.goibhniu ];
  };

}
