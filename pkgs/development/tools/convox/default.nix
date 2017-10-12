{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "convox-${version}";
  version = "20171007002353";

  meta = with stdenv.lib; {
    description = "Open-source PaaS";
    homepage = https://convox.com;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ shosti ];
  };

  goPackagePath = "github.com/convox/rack";
  subPackages = [ "cmd/convox" ];

  src = fetchFromGitHub {
    owner = "convox";
    repo = "rack";
    rev = version;
    sha256 = "1pggvcrq68jp9z0041jwc14i89bs69zgglbfbyk5lz8xgm4476l6";
  };
}
