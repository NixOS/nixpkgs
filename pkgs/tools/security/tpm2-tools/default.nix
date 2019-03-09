{ stdenv, fetchurl, fetchpatch, lib
, cmocka, curl, pandoc, pkgconfig, openssl, tpm2-tss }:

stdenv.mkDerivation rec {
  pname = "tpm2-tools";
  version = "3.1.3";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "05is1adwcg7y2p121yldd8m1gigdnzf9izbjazvsr6yg95pmg5fc";
  };

  patches = [
    (fetchpatch {
      name = "tests-tss-2.2.0-compat.patch";
      url = "https://patch-diff.githubusercontent.com/raw/tpm2-software/tpm2-tools/pull/1322.patch";
      sha256 = "0yy5qbgbd13d7cl8pzsji95a6qnwiik5s2cyqj35jd8blymikqxh";
    })
  ];

  nativeBuildInputs = [ pandoc pkgconfig ];
  buildInputs = [
    curl openssl tpm2-tss
    # For unit tests.
    cmocka
  ];

  configureFlags = [ "--enable-unit" ];
  doCheck = true;

  meta = with lib; {
    description = "Command line tools that provide access to a TPM 2.0 compatible device";
    homepage = https://github.com/tpm2-software/tpm2-tools;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
