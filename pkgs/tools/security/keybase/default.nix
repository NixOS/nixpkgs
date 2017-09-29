{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "1.0.30";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner  = "keybase";
    repo   = "client";
    rev    = "v${version}";
    sha256 = "0vivc71xfi4y3ydd29b17qxzi10r3a1ppmjjws6vrs0gz58bz1j8";
  };

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -delete_rpath $out/lib $bin/bin/keybase
  '';

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
