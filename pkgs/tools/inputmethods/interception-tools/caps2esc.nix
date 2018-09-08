{ stdenv, fetchurl, cmake }:

let
  version = "0.1.0";
  pname = "interception-tools-caps2esc";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://gitlab.com/interception/linux/plugins/caps2esc/repository/v${version}/archive.tar.gz";
    sha256 = "1fdxqp54gwsrm2c63168l256nfwdk4mvgr7nlwdv62wd3l7zzrg8";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/interception/linux/plugins/caps2esc;
    description = "Transforming the most useless key ever into the most useful one";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
}
