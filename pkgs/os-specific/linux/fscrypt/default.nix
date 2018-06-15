{ stdenv, buildGoPackage, fetchFromGitHub, pam }:

# Don't use this for anything important yet!

buildGoPackage rec {
  name = "fscrypt-${version}";
  version = "0.2.3";

  goPackagePath = "github.com/google/fscrypt";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    sha256 = "126bbxim4nj56kplvyv528i88mfray50r2rc6ysblkmaw6x0fd9c";
  };

  buildInputs = [ pam ];

  meta = with stdenv.lib; {
    description =
      "A high-level tool for the management of Linux filesystem encryption";
    longDescription = ''
      This tool manages metadata, key generation, key wrapping, PAM integration,
      and provides a uniform interface for creating and modifying encrypted
      directories.
    '';
    inherit (src.meta) homepage;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
