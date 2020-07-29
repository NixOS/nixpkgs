{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "udpt";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "naim94a";
    repo = "udpt";
    rev = "${pname}-${version}";
    sha256 = "1g6l0y5x9pdra3i1npkm474glysicm4hf2m01700ack2rp43vldr";
  };

  cargoSha256 = "1cmd80ndjxdmyfjpm1f04rwf64501nyi6wdsj7lxidgd1v92wy2c";
  verifyCargoDeps = true;

  postInstall = ''
    install -D udpt.toml $out/share/udpt/udpt.toml
  '';

  meta = {
    description = "A lightweight UDP torrent tracker";
    homepage = "https://naim94a.github.io/udpt";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
  };
}
