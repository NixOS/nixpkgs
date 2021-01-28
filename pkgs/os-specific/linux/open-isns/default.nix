{ lib, stdenv, openssl, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "open-isns";
  version = "0.100";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "0d0dz965azsisvfl5wpp1b7m0q0fmaz5r7x5dfybkry551sbcydr";
  };

  patches = [
    (fetchpatch {
      name = "deprecated-sighold-sigrelease";
      url = "https://github.com/open-iscsi/open-isns/commit/e7dac76ce61039fefa58985c955afccb60dabe87.patch";
      sha256 = "15v106xn3ns7z4nlpby7kkm55rm9qncsmy2iqc4ifli0h67g34id";
    })
    (fetchpatch {
      name = "warn_unused_result";
      url = "https://github.com/open-iscsi/open-isns/commit/4c39cb09735a494099fba0474d25ff26800de952.patch";
      sha256 = "1jlydrh9rgkky698jv0mp2wbbizn90q5wjbay086l0h6iqp8ibc3";
    })
  ];

  propagatedBuildInputs = [ openssl ];
  outputs = [ "out" "lib" ];
  outputInclude = "lib";

  configureFlags = [ "--enable-shared" ];

  installFlags = [ "etcdir=$(out)/etc" "vardir=$(out)/var/lib/isns" ];
  installTargets = [ "install" "install_hdrs" "install_lib" ];

  meta = with lib; {
    description = "iSNS server and client for Linux";
    license = licenses.lgpl21Only;
    homepage = "https://github.com/open-iscsi/open-isns";
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
