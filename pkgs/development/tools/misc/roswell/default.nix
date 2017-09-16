{ autoconf
, automake
, bash
, buildFHSUserEnv
, curl
, fetchFromGitHub
, stdenv
, writeTextFile
}:

let
  product = "roswell";
  version = "17.9.10.82";

  roswell = stdenv.mkDerivation rec {
    name = "${product}-${version}";

    src = fetchFromGitHub {
      owner = product;
      repo = product;
      rev = "v${version}";
      sha256 = "1064lj5hy70j7nkf46h7pg5yvksgaj3k9aha7gp09hd826857q4m";
    };

    preConfigure = ''
      sh bootstrap
    '';

    buildInputs = [ curl ];

    nativeBuildInputs = [ autoconf automake ];

    meta = with stdenv.lib; {
      homepage = https://github.com/roswell/roswell;
      description = "Lisp installer and launcher for major environments that just works";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  fhsEnv = buildFHSUserEnv {
    name = "${product}-${version}-fhs-env";

    targetPkgs = pkgs: (with pkgs; [ bash gnumake stdenv.cc ]);
  };

in
  if !stdenv.isDarwin then
    writeTextFile {
      name = "${product}-${version}";

      executable = true;

      destination = "/bin/ros";

      text = ''
        #!${fhsEnv}/bin/${fhsEnv.name}
        ${roswell}/bin/ros $@
      '';
    }
  else
    roswell
