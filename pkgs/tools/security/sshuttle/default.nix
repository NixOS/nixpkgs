{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper, pandoc
, coreutils, iptables, nettools, openssh, procps,  pythonPackages }:
  
let version = "0.71"; in
stdenv.mkDerivation rec {
  name = "sshuttle-${version}";

  src = fetchFromGitHub {
    sha256 = "0yr8nih97jg6azfj3k7064lfbh3g36l6vwyjlngl4ph6mgcki1cm";
    rev = name;
    repo = "sshuttle";
    owner = "sshuttle";
  };

  patches = [
    (fetchpatch {
      sha256 = "1yrjyvdz6k6zk020dmbagf8w49w8vhfbzgfpsq9jqdh2hbykv3m3";
      url = https://github.com/sshuttle/sshuttle/commit/3cf5002b62650c26a50e18af8d8c5c91d754bab9.patch;
    })
    (fetchpatch {
      sha256 = "091gg28cnmx200q46bcnxpp9ih9p5qlq0r3bxfm0f4qalg8rmp2g";
      url = https://github.com/sshuttle/sshuttle/commit/d70b5f2b89e593506834cf8ea10785d96c801dfc.patch;
    })
    (fetchpatch {
      sha256 = "17l9h8clqlbyxdkssavxqpb902j7b3yabrrdalybfpkhj69x8ghk";
      url = https://github.com/sshuttle/sshuttle/commit/a38963301e9c29fbe3232f0a41ea080b642c5ad2.patch;
    })
  ];

  nativeBuildInputs = [ makeWrapper pandoc ];
  buildInputs =
    [ coreutils iptables nettools openssh procps pythonPackages.python ];
  pythonPaths = with pythonPackages; [ PyXAPI ];

  preConfigure = ''
    cd src
  '';

  installPhase = let
    mapPath = f: x: stdenv.lib.concatStringsSep ":" (map f x);
  in ''
    mkdir -p $out/share/sshuttle
    cp -R sshuttle *.py compat $out/share/sshuttle

    mkdir -p $out/bin
    ln -s $out/share/sshuttle/sshuttle $out/bin
    wrapProgram $out/bin/sshuttle \
      --prefix PATH : "${mapPath (x: "${x}/bin") buildInputs}" \
      --prefix PYTHONPATH : "${mapPath (x: "$(toPythonPath ${x})") pythonPaths}"

    install -Dm644 sshuttle.8 $out/share/man/man8/sshuttle.8
  '';
  
  meta = with stdenv.lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "Transparent proxy server that works as a poor man's VPN";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2 at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    maintainers = with maintainers; [ iElectric nckx ];
    platforms = platforms.unix;
  };
}
