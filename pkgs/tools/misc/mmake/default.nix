{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mmake-${version}";
  version = "1.2.0";
  baseurl = "https://github.com/tj/mmake/releases/download/v${version}";

  src = if stdenv.system == "i686-linux" then fetchurl {
    url = "${baseurl}/mmake_linux_386";
    sha256 = "1sa1ilfjb4c6vbqc45l5qibvizkzp0sq41s4fj1r4gj9yw1sknf3";
  } else if stdenv.system == "x86_64-linux" then fetchurl {
    url = "${baseurl}/mmake_linux_amd64";
    sha256 = "15gnzir4lckm24m8k8ssw51a9sfmqawh4qh9gkcx1h9zdwc9xxcz";
  } else if stdenv.system == "i686-darwin" then fetchurl {
    url = "${baseurl}/mmake_darwin_386";
    sha256 = "0lg92dkdcbc0nf34qaw42n7rvhw8zqmbnjxdchrvnz6nlrwki0ix";
  } else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = "${baseurl}/mmake_darwin_amd64";
    sha256 = "1g569mqqw6m9488mx6mmj5mxcc29nyqb22r935aj4kbbxijf2asc";
  } else if stdenv.system == "i686-openbsd" then fetchurl {
    url = "${baseurl}/mmake_openbsd_386";
    sha256 = "186k7f6mylkr210nsvsdsfq7x99wsvm9yy8awdp2in2z2bpd1nsm";
  } else if stdenv.system == "x86_64-openbsd" then fetchurl {
    url = "${baseurl}/mmake_openbsd_amd64";
    sha256 = "1g3yyrh2k5ifay293brin79zvshnl0ky1gxw5lwz8ivwzvhlwi3f";
  } else throw "platform ${stdenv.system} not supported!";

  installPhase = ''
    install -D $src $out/bin/mmake
  '';

  phases = [ "installPhase" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tj/mmake;
    description = "Mmake is a small program which wraps make to provide additional functionality, such as user-friendly help output, remote includes, and eventually more. It otherwise acts as a pass-through to standard make.";
    license = licenses.mit;
    platforms = [ "i686-openbsd" "x86_64-darwin" "i686-darwin" "x86_64-linux" "i686-linux" "x86_64-openbsd" ];
  };
}
