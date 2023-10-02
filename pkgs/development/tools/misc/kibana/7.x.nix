{ elk7Version
, enableUnfree ? true
, lib
, stdenv
, makeWrapper
, fetchurl
, nodejs_16
, coreutils
, which
}:

let
  nodejs = nodejs_16;
  inherit (builtins) elemAt;
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  hashes =
    {
      x86_64-linux  = "sha512-09XokG5krjxGnk34DhxpLOGRLjb2jd82uZtwGfrzSuuqMpBhkEptK2oySGxuGdHF8uowwlR5p5YO2TvBwMsWkQ==";
      x86_64-darwin = "sha512-cqRJnvu730Jfkr6vwbHUFuZube1g522cmvnDwTzhGGK6VN/7+9XL3vavqtUPDVdTLTUk+DrNiIQK7MaJH3SHMg==";
      aarch64-linux = "sha512-zhtYThz5j4+w5gI1JWSnHv709Tk23eegVsrtYmdaYhZiTw2yvCTYI5uNAfBjBr8XPdp6CKF4e6Bh2wHKDYg1mg==";
      aarch64-darwin = "sha512-cqRJnvu730Jfkr6vwbHUFuZube1g522cmvnDwTzhGGK6VN/7+9XL3vavqtUPDVdTLTUk+DrNiIQK7MaJH3SHMg==";
    };

in stdenv.mkDerivation rec {
  pname = "kibana";
  version = elk7Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${pname}-${version}-${plat}-${arch}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  patches = [
    # Kibana specifies it specifically needs nodejs 10.15.2 but nodejs in nixpkgs is at 10.15.3.
    # The <nixpkgs/nixos/tests/elk.nix> test succeeds with this newer version so lets just
    # disable the version check.
    ./disable-nodejs-version-check-7.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/kibana $out/bin
    mv * $out/libexec/kibana/
    rm -r $out/libexec/kibana/node
    makeWrapper $out/libexec/kibana/bin/kibana $out/bin/kibana \
      --prefix PATH : "${lib.makeBinPath [ nodejs coreutils which ]}"
    sed -i 's@NODE=.*@NODE=${nodejs}/bin/node@' $out/libexec/kibana/bin/kibana
  '';

  meta = with lib; {
    description = "Visualize logs and time-stamped data";
    homepage = "http://www.elasticsearch.org/overview/kibana";
    license = licenses.elastic;
    maintainers = with maintainers; [ offline basvandijk ];
    platforms = with platforms; unix;
  };
}
