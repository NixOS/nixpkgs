{ stdenv, fetchurl, libresolv }:

stdenv.mkDerivation rec {
  version = "1.9";
  name = "dnstracer-${version}";

  src = fetchurl {
    url = "https://www.mavetju.org/download/${name}.tar.gz";
    sha256 = "177y58smnq2xhx9lbmj1gria371iv3r1d132l2gjvflkjsphig1f";
  };

  outputs = [ "out" "man" ];

  setOutputFlags = false;

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [ libresolv ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lresolv";

  meta = with stdenv.lib; {
    description = "Dnstracer determines where a given Domain Name Server (DNS) gets its information from, and follows the chain of DNS servers back to the servers which know the data.";
    homepage = http://www.mavetju.org/unix/general.php;
    license = licenses.bsd2;
    maintainers = with maintainers; [ andir ];
    platforms = platforms.all;
  };
}
