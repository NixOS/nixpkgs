{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "apg-2.3.0b";
  src = fetchurl {
    url = "http://www.adel.nursat.kz/apg/download/${name}.tar.gz";
    sha256 = "14lbq81xrcsmpk1b9qmqyz7n6ypf08zcxvcvp6f7ybcyf0lj1rfi";
  };
  configurePhase = ''
    substituteInPlace Makefile --replace /usr/local "$out"
    substituteInPlace rnd.h --replace "/dev/random" "/dev/urandom"
  '';

  patches = [ ./apg.patch ];

  meta = {
    description = "Tools for random password generation";
    longDescription = ''
      APG (Automated Password Generator) is the tool set for random
      password generation.

      Standalone version

        Generates some random words of required type and prints them
        to standard output.

      Network version

        APG server: When client's request is arrived generates some
        random words of predefined type and send them to client over
        the network (according to RFC0972).

        APG client: Sends the password generation request to the APG
        server, wait for generated Passwords arrival and then prints
        them to the standard output.

     Advantages

       * Built-in ANSI X9.17 RNG (Random Number Generator) (CAST/SHA1)
       * Built-in password quality checking system (it has support for
         Bloom filter for faster access)
       * Two Password Generation Algorithms:
           1. Pronounceable Password Generation Algorithm (according to
              NIST FIPS 181)
           2. Random Character Password Generation Algorithm with 35
              configurable modes of operation
       * Configurable password length parameters
       * Configurable amount of generated passwords
       * Ability to initialize RNG with user string
       * Support for /dev/random
       * Ability to crypt() generated passwords and print them as
         additional output
       * Special parameters to use APG in script
       * Ability to log password generation requests for network version
       * Ability to control APG service access using tcpd
       * Ability to use password generation service from any type of box
         (Mac, WinXX, etc.) that connected to network
       * Ability to enforce remote users to use only allowed type of
         password generation
    '';
    homepage = http://www.adel.nursat.kz/apg/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
