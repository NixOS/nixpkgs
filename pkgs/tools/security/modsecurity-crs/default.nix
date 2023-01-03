{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "3.3.4";
  pname = "modsecurity-crs";

  src = fetchFromGitHub {
    owner = "coreruleset";
    repo = "coreruleset";
    rev = "v${version}";
    sha256 = "sha256-WDJW4K85YdHrw9cys3LrnZUoTxc0WhiuCW6CiC1cAbk=";
  };

  installPhase = ''
    install -D -m444 -t $out/rules ${src}/rules/*.conf
    install -D -m444 -t $out/rules ${src}/rules/*.data
    install -D -m444 -t $out/share/doc/modsecurity-crs ${src}/*.md
    install -D -m444 -t $out/share/doc/modsecurity-crs ${src}/{CHANGES,INSTALL,LICENSE}
    install -D -m444 -t $out/share/modsecurity-crs ${src}/rules/*.example
    install -D -m444 -t $out/share/modsecurity-crs ${src}/crs-setup.conf.example
    cat > $out/share/modsecurity-crs/modsecurity-crs.load.example <<EOF
    ##
    ## This is a sample file for loading OWASP CRS's rules.
    ##
    Include /etc/modsecurity/crs/crs-setup.conf
    IncludeOptional /etc/modsecurity/crs/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
    Include $out/rules/*.conf
    IncludeOptional /etc/modsecurity/crs/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
    EOF
  '';

  meta = with lib; {
    homepage = "https://coreruleset.org";
    description = ''
      The OWASP ModSecurity Core Rule Set is a set of generic attack detection
      rules for use with ModSecurity or compatible web application firewalls.
    '';
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
