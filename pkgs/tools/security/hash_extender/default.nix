{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "hash_extender";
  version = "2017-04-10";

  src = fetchFromGitHub {
    owner = "iagox86";
    repo = "hash_extender";
    rev = "d27581e062dd0b534074e11d7d311f65a6d7af21";
    sha256 = "1npwbgqaynjh5x39halw43i116v89sxkpa1g1bbvc1lpi8hkhhcb";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    mkdir -p $out/bin
    cp hash_extender $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Tool to automate hash length extension attacks";
    homepage = https://github.com/iagox86/hash_extender;
    license = licenses.bsd3;
    maintainers = with maintainers; [ geistesk ];
  };
}
