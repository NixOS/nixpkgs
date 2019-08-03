{ stdenv, lib, fetchFromGitHub, autoreconfHook, libsodium }:

stdenv.mkDerivation rec {
  name = "mkp224o-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cathugger";
    repo = "mkp224o";
    rev = "v${version}";
    sha256 = "1il12ahcs5pj52hxn4xvpjfz801xcg31zk2jnkl80frzlwq040qi";
  };

  buildCommand =
    let
      # compile few variants with different implementation of crypto
      # the fastest depends on a particular cpu
      variants = [
        { suffix = "ref10";         configureFlags = ["--enable-ref10"]; }
        { suffix = "donna";         configureFlags = ["--enable-donna"]; }
      ] ++ lib.optionals (stdenv.isi686 || stdenv.isx86_64) [
        { suffix = "donna-sse2";    configureFlags = ["--enable-donna-sse2"]; }
      ] ++ lib.optionals stdenv.isx86_64 [
        { suffix = "amd64-51-30k";  configureFlags = ["--enable-amd64-51-30k"]; }
        { suffix = "amd64-64-20k";  configureFlags = ["--enable-amd64-64-24k"]; }
      ];
    in
      lib.concatMapStrings ({suffix, configureFlags}: ''
        install -D ${
          stdenv.mkDerivation {
            name = "mkp224o-${suffix}-${version}";
            inherit version src configureFlags;
            nativeBuildInputs = [ autoreconfHook ];
            buildInputs = [ libsodium ];
            installPhase = "install -D mkp224o $out";
          }
        } $out/bin/mkp224o-${suffix}
      '') variants;

  meta = with lib; {
    description = "Vanity address generator for tor onion v3 (ed25519) hidden services";
    homepage = http://cathug2kyi4ilneggumrenayhuhsvrgn6qv2y47bgeet42iivkpynqad.onion/;
    license = licenses.cc0;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volth ];
  };
}
