{ stdenv, fetchurl, libsepol }:

stdenv.mkDerivation rec {
  name = "semodule-utils-${version}";
  version = "2.7";

  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/${name}.tar.gz";
    sha256 = "1fl60x4w8rn5bcwy68sy48aydwsn1a17d48slni4sfx4c8rqpjch";
  };

  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${stdenv.lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = with stdenv.lib; {
    description = "SELinux policy core utilities (packaging additions)";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms;
    maintainers = [ maintainers.e-user ];
  };
}
