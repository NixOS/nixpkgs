{ stdenv, fetchFromGitHub, buildPerlPackage, perlPackages, makeWrapper}:

buildPerlPackage rec {
  name = "linode-cli-${version}";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "linode";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1wiz067wgxi4z4rz4n9p7dlvx5z4hkl2nxpfvhikl6dri4m2nkkp";
  };

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = with perlPackages; [
    JSON
    LWPUserAgent
    MozillaCA
    TryTiny
    WebServiceLinode
  ];

  # Wrap perl scripts so they can find libraries
  postInstall = ''
    for n in "$out/bin"/*; do
      wrapProgram "$n" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

  # Has no tests
  doCheck = false;

  # Has no "doc" or "devdoc" outputs
  outputs = [ "out" ];

  meta = with stdenv.lib; {
    description = "Command-line interface to the Linode platform";
    homepage = https://github.com/linode/cli;
    license = with licenses; [ artistic2 gpl2 ];
    maintainers = with maintainers; [ nixy ];
  };
}
