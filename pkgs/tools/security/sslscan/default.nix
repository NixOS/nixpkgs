{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "sslscan-${version}";
  version = "1.11.7";

  src = fetchurl {
    url = "https://github.com/rbsec/sslscan/archive/${version}-rbsec.tar.gz";
    sha256 = "0wygz2gm9asvhpfy44333y4pkdja1sbr41hc6mhkxg7a4ys8f9qs";
  };

  buildInputs = [ openssl ];

  installFlags = [
    "PREFIX=$(out)"
  ];

  patches = [
    # this patch can be removed after post-1.11.7 release
    (fetchurl {
      url = "https://github.com/rbsec/sslscan/commit/b076e67819ebe69d1bd34c66a7000630d27791d7.patch";
      sha256 = "08cszm9hh3ljxm7m66l7lqdpiarb55bsbwdan3by6dy5l843yhgz";
    })
  ];

  meta = with stdenv.lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = https://github.com/rbsec/sslscan;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.all;
  };
}

