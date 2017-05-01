{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "the_platinum_searcher-${version}";
  version = "2.1.5";
  rev = "v${version}";

  goPackagePath = "github.com/monochromegane/the_platinum_searcher";

  src = fetchFromGitHub {
    inherit rev;
    owner = "monochromegane";
    repo = "the_platinum_searcher";
    sha256 = "1y7kl3954dimx9hp2bf1vjg1h52hj1v6cm4f5nhrqzwrawp0b6q0";
  };

  goDeps = ./deps.nix;

  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    # fixes cycle between $out and $bin
    install_name_tool -delete_rpath $out/lib $bin/bin/pt
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/monochromegane/the_platinum_searcher;
    description = "A code search tool similar to ack and the_silver_searcher(ag).";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
