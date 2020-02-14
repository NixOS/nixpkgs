{ stdenv, fetchFromGitHub, perlPackages }:

perlPackages.buildPerlPackage {
  pname = "rename";
  version = "1.9";
  outputs = [ "out" ];
  src = fetchFromGitHub {
    owner = "pstray";
    repo = "rename";
    rev = "d46f1d0ced25dc5849acb5d5974a3e2e9d97d536";
    sha256 = "0qahs1cqfaci2hdf1xncrz4k0z5skkfr43apnm3kybs7za33apzw";
  };
  meta = with stdenv.lib; {
    description = "Rename files according to a Perl rewrite expression";
    homepage = "https://github.com/pstray/rename";
    maintainers = with maintainers; [ mkg ];
    license = with licenses; [ gpl1Plus ];
  };
}
