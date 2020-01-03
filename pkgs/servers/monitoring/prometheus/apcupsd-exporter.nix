{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "apcupsd-exporter";
  version = "unstable-2019-03-14";

  goPackagePath = "github.com/mdlayher/apcupsd_exporter";

  goDeps = ./apcupsd-exporter_deps.nix;

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "apcupsd_exporter";
    rev = "cbd49be";
    sha256 = "1h5z295m9bddch5bc8fppn02b31h370yns6026a1d4ygfy3w46y0";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Provides a Prometheus exporter for the apcupsd Network Information Server (NIS)";
    homepage = "https://github.com/mdlayher/apcupsd_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers."1000101" ];
    platforms = platforms.all;
  };
}
