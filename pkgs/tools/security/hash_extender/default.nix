{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation {
  pname = "hash_extender";
  version = "unstable-2020-03-24";

  src = fetchFromGitHub {
    owner = "iagox86";
    repo = "hash_extender";
    rev = "cb8aaee49f93e9c0d2f03eb3cafb429c9eed723d";
    sha256 = "1fj118566hr1wv03az2w0iqknazsqqkak0mvlcvwpgr6midjqi9b";
  };

  buildInputs = [ openssl ];

  doCheck = true;
  checkPhase = "./hash_extender --test";

  installPhase = ''
    mkdir -p $out/bin
    cp hash_extender $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Tool to automate hash length extension attacks";
    homepage = "https://github.com/iagox86/hash_extender";
    license = licenses.bsd3;
    maintainers = with maintainers; [ geistesk ];
  };
}
